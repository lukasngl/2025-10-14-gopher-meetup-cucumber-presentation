// Package measurementrepo provides a PostgreSQL implementation of the measurement repository.
package measurementrepo

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"example.invalid/domain/measurement"
	"example.invalid/domain/template"

	"github.com/jackc/pgx/v5/pgxpool"
)

// MeasurementRepository is a PostgreSQL implementation of measurement.Repository.
type MeasurementRepository struct {
	pool         *pgxpool.Pool
	templateRepo template.Repository
}

// New creates a new SQL-based measurement repository.
// Requires a template repository to load templates when reconstructing measurements.
func New(pool *pgxpool.Pool, templateRepo template.Repository) *MeasurementRepository {
	return &MeasurementRepository{
		pool:         pool,
		templateRepo: templateRepo,
	}
}

// Migrate creates the measurements table if it doesn't exist.
func (r *MeasurementRepository) Migrate(ctx context.Context) error {
	query := `
		CREATE TABLE IF NOT EXISTS measurements (
			id SERIAL PRIMARY KEY,
			template_id TEXT NOT NULL REFERENCES templates(id),
			status TEXT NOT NULL,
			started_at TIMESTAMP NOT NULL,
			finished_at TIMESTAMP,
			measured_values JSONB NOT NULL DEFAULT '[]'
		)
	`
	_, err := r.pool.Exec(ctx, query)
	return err
}

// valueJSON is a helper struct for JSON serialization of measured values.
type valueJSON struct {
	Value          float64 `json:"value"`
	InSpec         bool    `json:"in_spec"`
	DimensionLabel string  `json:"dimension_label"`
}

// Create creates a new measurement and returns its ID.
func (r *MeasurementRepository) Create(ctx context.Context, meas measurement.Measurement) (int, error) {
	// Serialize measured values to JSON
	values := meas.Values()
	jsonValues := make([]valueJSON, len(values))
	for i, v := range values {
		jsonValues[i] = valueJSON{
			Value:          v.Value(),
			InSpec:         v.InSpec(),
			DimensionLabel: v.DimensionLabel().String(),
		}
	}

	valuesJSON, err := json.Marshal(jsonValues)
	if err != nil {
		return 0, fmt.Errorf("failed to marshal values: %w", err)
	}

	// Determine finished_at (may be nil)
	var finishedAt *time.Time
	if meas.IsFinished() {
		now := time.Now()
		finishedAt = &now
	}

	query := `
		INSERT INTO measurements (template_id, status, started_at, finished_at, measured_values)
		VALUES ($1, $2, $3, $4, $5)
		RETURNING id
	`

	var id int
	err = r.pool.QueryRow(ctx, query,
		meas.Template().ID().String(),
		meas.Status().String(),
		time.Now(), // started_at
		finishedAt,
		valuesJSON,
	).Scan(&id)

	if err != nil {
		return 0, fmt.Errorf("failed to create measurement: %w", err)
	}

	return id, nil
}

// Read returns the measurement with the given ID.
func (r *MeasurementRepository) Read(ctx context.Context, id int) (measurement.Measurement, error) {
	query := `
		SELECT id, template_id, status, started_at, finished_at, measured_values
		FROM measurements
		WHERE id = $1
	`

	var measID int
	var templateID string
	var status string
	var startedAt time.Time
	var finishedAt *time.Time
	var valuesJSON []byte

	err := r.pool.QueryRow(ctx, query, id).Scan(&measID, &templateID, &status, &startedAt, &finishedAt, &valuesJSON)
	if err != nil {
		return measurement.Measurement{}, fmt.Errorf("messung nicht gefunden: %w", err)
	}

	// Load the template
	tmplID, err := template.NewID(templateID)
	if err != nil {
		return measurement.Measurement{}, fmt.Errorf("invalid template ID: %w", err)
	}

	tmpl, err := r.templateRepo.Read(ctx, tmplID)
	if err != nil {
		return measurement.Measurement{}, fmt.Errorf("failed to load template: %w", err)
	}

	// Create new measurement
	meas := measurement.New(measID, tmpl)

	// Deserialize and apply measured values
	var jsonValues []valueJSON
	if err := json.Unmarshal(valuesJSON, &jsonValues); err != nil {
		return measurement.Measurement{}, fmt.Errorf("failed to unmarshal values: %w", err)
	}

	// Re-apply all observed values to reconstruct the measurement state
	for _, jv := range jsonValues {
		label, err := template.NewLabel(jv.DimensionLabel)
		if err != nil {
			return measurement.Measurement{}, fmt.Errorf("invalid dimension label: %w", err)
		}
		if err := meas.ObserveValue(label, jv.Value); err != nil {
			return measurement.Measurement{}, fmt.Errorf("failed to reconstruct measurement: %w", err)
		}
	}

	return meas, nil
}

// Update updates an existing measurement by applying updateFn.
func (r *MeasurementRepository) Update(ctx context.Context, id int, updateFn func(*measurement.Measurement) error) error {
	tx, err := r.pool.Begin(ctx)
	if err != nil {
		return fmt.Errorf("failed to begin transaction: %w", err)
	}
	defer tx.Rollback(ctx)

	// Read current state with row lock
	query := `
		SELECT id, template_id, status, started_at, finished_at, measured_values
		FROM measurements
		WHERE id = $1
		FOR UPDATE
	`

	var measID int
	var templateID string
	var status string
	var startedAt time.Time
	var finishedAt *time.Time
	var valuesJSON []byte

	err = tx.QueryRow(ctx, query, id).Scan(&measID, &templateID, &status, &startedAt, &finishedAt, &valuesJSON)
	if err != nil {
		return fmt.Errorf("messung nicht gefunden: %w", err)
	}

	// Load the template
	tmplID, err := template.NewID(templateID)
	if err != nil {
		return fmt.Errorf("invalid template ID: %w", err)
	}

	tmpl, err := r.templateRepo.Read(ctx, tmplID)
	if err != nil {
		return fmt.Errorf("failed to load template: %w", err)
	}

	// Reconstruct measurement
	meas := measurement.New(measID, tmpl)

	// Deserialize and apply measured values
	var jsonValues []valueJSON
	if err := json.Unmarshal(valuesJSON, &jsonValues); err != nil {
		return fmt.Errorf("failed to unmarshal values: %w", err)
	}

	for _, jv := range jsonValues {
		label, err := template.NewLabel(jv.DimensionLabel)
		if err != nil {
			return fmt.Errorf("invalid dimension label: %w", err)
		}
		if err := meas.ObserveValue(label, jv.Value); err != nil {
			return fmt.Errorf("failed to reconstruct measurement: %w", err)
		}
	}

	// Apply update function
	if err := updateFn(&meas); err != nil {
		return err
	}

	// Serialize updated values
	values := meas.Values()
	updatedJsonValues := make([]valueJSON, len(values))
	for i, v := range values {
		updatedJsonValues[i] = valueJSON{
			Value:          v.Value(),
			InSpec:         v.InSpec(),
			DimensionLabel: v.DimensionLabel().String(),
		}
	}

	updatedValuesJSON, err := json.Marshal(updatedJsonValues)
	if err != nil {
		return fmt.Errorf("failed to marshal updated values: %w", err)
	}

	// Determine finished_at
	var updatedFinishedAt *time.Time
	if meas.IsFinished() {
		if finishedAt == nil {
			// Just finished, set timestamp
			now := time.Now()
			updatedFinishedAt = &now
		} else {
			// Already finished, keep original timestamp
			updatedFinishedAt = finishedAt
		}
	}

	// Save updated state
	updateQuery := `
		UPDATE measurements
		SET status = $1, finished_at = $2, measured_values = $3
		WHERE id = $4
	`

	_, err = tx.Exec(ctx, updateQuery,
		meas.Status().String(),
		updatedFinishedAt,
		updatedValuesJSON,
		id,
	)
	if err != nil {
		return fmt.Errorf("failed to update measurement: %w", err)
	}

	return tx.Commit(ctx)
}

// ListByTemplate returns all measurements for a specific template.
func (r *MeasurementRepository) ListByTemplate(ctx context.Context, templateID template.ID) ([]measurement.Measurement, error) {
	query := `
		SELECT id, template_id, status, started_at, finished_at, measured_values
		FROM measurements
		WHERE template_id = $1
		ORDER BY id
	`

	rows, err := r.pool.Query(ctx, query, templateID.String())
	if err != nil {
		return nil, fmt.Errorf("failed to list measurements: %w", err)
	}
	defer rows.Close()

	// Load the template once
	tmpl, err := r.templateRepo.Read(ctx, templateID)
	if err != nil {
		return nil, fmt.Errorf("failed to load template: %w", err)
	}

	var measurements []measurement.Measurement
	for rows.Next() {
		var measID int
		var templateIDStr string
		var status string
		var startedAt time.Time
		var finishedAt *time.Time
		var valuesJSON []byte

		if err := rows.Scan(&measID, &templateIDStr, &status, &startedAt, &finishedAt, &valuesJSON); err != nil {
			return nil, fmt.Errorf("failed to scan measurement: %w", err)
		}

		// Create new measurement
		meas := measurement.New(measID, tmpl)

		// Deserialize and apply measured values
		var jsonValues []valueJSON
		if err := json.Unmarshal(valuesJSON, &jsonValues); err != nil {
			return nil, fmt.Errorf("failed to unmarshal values: %w", err)
		}

		for _, jv := range jsonValues {
			label, err := template.NewLabel(jv.DimensionLabel)
			if err != nil {
				return nil, fmt.Errorf("invalid dimension label: %w", err)
			}
			if err := meas.ObserveValue(label, jv.Value); err != nil {
				return nil, fmt.Errorf("failed to reconstruct measurement: %w", err)
			}
		}

		measurements = append(measurements, meas)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("error iterating measurements: %w", err)
	}

	return measurements, nil
}

// Ensure MeasurementRepository implements measurement.Repository
var _ measurement.Repository = (*MeasurementRepository)(nil)

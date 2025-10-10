// Package templaterepo provides a PostgreSQL implementation of the template repository.
package templaterepo

import (
	"context"
	"encoding/json"
	"fmt"

	"example.invalid/domain/template"
	"example.invalid/domain/unit"

	"github.com/jackc/pgx/v5/pgxpool"
)

// TemplateRepository is a PostgreSQL implementation of template.Repository.
type TemplateRepository struct {
	pool *pgxpool.Pool
}

// New creates a new SQL-based template repository.
func New(pool *pgxpool.Pool) *TemplateRepository {
	return &TemplateRepository{
		pool: pool,
	}
}

// Migrate creates the templates table if it doesn't exist.
func (r *TemplateRepository) Migrate(ctx context.Context) error {
	query := `
		CREATE TABLE IF NOT EXISTS templates (
			id TEXT PRIMARY KEY,
			dimensions JSONB NOT NULL
		)
	`
	_, err := r.pool.Exec(ctx, query)
	return err
}

// dimensionJSON is a helper struct for JSON serialization of dimensions.
type dimensionJSON struct {
	Label   string  `json:"label"`
	Unit    string  `json:"unit"`
	Nominal float64 `json:"nominal"`
	Upper   float64 `json:"upper"`
	Lower   float64 `json:"lower"`
}

// Create stores a new template.
func (r *TemplateRepository) Create(ctx context.Context, tmpl template.Template) error {
	// Serialize dimensions to JSON
	dims := tmpl.Dimensions()
	jsonDims := make([]dimensionJSON, len(dims))
	for i, d := range dims {
		jsonDims[i] = dimensionJSON{
			Label:   d.Label.String(),
			Unit:    d.Unit.String(),
			Nominal: d.Nominal,
			Upper:   d.Upper,
			Lower:   d.Lower,
		}
	}

	dimensionsJSON, err := json.Marshal(jsonDims)
	if err != nil {
		return fmt.Errorf("failed to marshal dimensions: %w", err)
	}

	query := `INSERT INTO templates (id, dimensions) VALUES ($1, $2)`
	_, err = r.pool.Exec(ctx, query, tmpl.ID().String(), dimensionsJSON)
	if err != nil {
		return fmt.Errorf("failed to create template: %w", err)
	}

	return nil
}

// Read returns the template with the given ID.
func (r *TemplateRepository) Read(ctx context.Context, id template.ID) (template.Template, error) {
	query := `SELECT id, dimensions FROM templates WHERE id = $1`

	var idStr string
	var dimensionsJSON []byte

	err := r.pool.QueryRow(ctx, query, id.String()).Scan(&idStr, &dimensionsJSON)
	if err != nil {
		return template.Template{}, fmt.Errorf("template nicht gefunden: %w", err)
	}

	// Deserialize dimensions
	var jsonDims []dimensionJSON
	if err := json.Unmarshal(dimensionsJSON, &jsonDims); err != nil {
		return template.Template{}, fmt.Errorf("failed to unmarshal dimensions: %w", err)
	}

	// Convert to domain types
	dims := make([]template.Dimension, len(jsonDims))
	for i, jd := range jsonDims {
		label, err := template.NewLabel(jd.Label)
		if err != nil {
			return template.Template{}, fmt.Errorf("invalid label: %w", err)
		}
		unitVal, err := unit.NewUnit(jd.Unit)
		if err != nil {
			return template.Template{}, fmt.Errorf("invalid unit: %w", err)
		}
		dims[i] = template.Dimension{
			Label:   label,
			Unit:    unitVal,
			Nominal: jd.Nominal,
			Upper:   jd.Upper,
			Lower:   jd.Lower,
		}
	}

	// Reconstruct template
	templateID, err := template.NewID(idStr)
	if err != nil {
		return template.Template{}, fmt.Errorf("invalid template ID: %w", err)
	}

	tmpl, err := template.New(templateID, dims)
	if err != nil {
		return template.Template{}, fmt.Errorf("failed to create template: %w", err)
	}

	return tmpl, nil
}

// List returns all templates.
func (r *TemplateRepository) List(ctx context.Context) ([]template.Template, error) {
	query := `SELECT id, dimensions FROM templates ORDER BY id`

	rows, err := r.pool.Query(ctx, query)
	if err != nil {
		return nil, fmt.Errorf("failed to list templates: %w", err)
	}
	defer rows.Close()

	var templates []template.Template
	for rows.Next() {
		var idStr string
		var dimensionsJSON []byte

		if err := rows.Scan(&idStr, &dimensionsJSON); err != nil {
			return nil, fmt.Errorf("failed to scan template: %w", err)
		}

		// Deserialize dimensions
		var jsonDims []dimensionJSON
		if err := json.Unmarshal(dimensionsJSON, &jsonDims); err != nil {
			return nil, fmt.Errorf("failed to unmarshal dimensions: %w", err)
		}

		// Convert to domain types
		dims := make([]template.Dimension, len(jsonDims))
		for i, jd := range jsonDims {
			label, err := template.NewLabel(jd.Label)
			if err != nil {
				return nil, fmt.Errorf("invalid label: %w", err)
			}
			unitVal, err := unit.NewUnit(jd.Unit)
			if err != nil {
				return nil, fmt.Errorf("invalid unit: %w", err)
			}
			dims[i] = template.Dimension{
				Label:   label,
				Unit:    unitVal,
				Nominal: jd.Nominal,
				Upper:   jd.Upper,
				Lower:   jd.Lower,
			}
		}

		// Reconstruct template
		templateID, err := template.NewID(idStr)
		if err != nil {
			return nil, fmt.Errorf("invalid template ID: %w", err)
		}

		tmpl, err := template.New(templateID, dims)
		if err != nil {
			return nil, fmt.Errorf("failed to create template: %w", err)
		}

		templates = append(templates, tmpl)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("error iterating templates: %w", err)
	}

	return templates, nil
}

// Ensure TemplateRepository implements template.Repository
var _ template.Repository = (*TemplateRepository)(nil)

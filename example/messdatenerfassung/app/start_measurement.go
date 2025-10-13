package app

import (
	"context"
	"fmt"

	"example.invalid/domain/measurement"
	"example.invalid/domain/template"
)

// StartMeasurement represents a command to start a new measurement session.
type StartMeasurement struct {
	TemplateID template.ID
}

// StartMeasurementHandler handles the StartMeasurement command.
// Returns the ID of the newly created measurement.
type StartMeasurementHandler = QueryHandler[StartMeasurement, int]

// NewStartMeasurementHandler creates a new handler for starting measurements.
// The handler loads the template and creates a new measurement in PENDING status.
func NewStartMeasurementHandler(
	templateRepo template.Repository,
	measurementRepo measurement.Repository,
) QueryHandler[StartMeasurement, int] {
	return func(ctx context.Context, cmd StartMeasurement) (int, error) {
		// Load template
		tmpl, err := templateRepo.Read(ctx, cmd.TemplateID)
		if err != nil {
			return 0, fmt.Errorf("messvorlage nicht gefunden: %w", err)
		}

		// Create measurement (using next ID from repo)
		// Note: We'll use 0 as temporary ID, repo.Create will assign the real ID
		meas := measurement.New(0, tmpl)

		// Persist and get assigned ID
		id, err := measurementRepo.Create(ctx, meas)
		if err != nil {
			return 0, err
		}

		return id, nil
	}
}

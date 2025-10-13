package app

import (
	"context"

	"example.invalid/domain/measurement"
	"example.invalid/domain/template"
)

// MeasureValue represents a command to record a measured value.
type MeasureValue struct {
	MeasurementID int
	Label         template.Label
	Value         float64
}

// MeasureValueHandler handles the ObserveValue command.
type MeasureValueHandler = CommandHandler[MeasureValue]

// NewObserveValueHandler creates a new handler for recording measured values.
// The handler checks tolerances and may automatically transition the measurement
// to IN_SPEC or OUT_OF_SPEC status.
func NewObserveValueHandler(repo measurement.Repository) CommandHandler[MeasureValue] {
	return func(ctx context.Context, cmd MeasureValue) error {
		return repo.Update(ctx, cmd.MeasurementID, func(meas *measurement.Measurement) error {
			return meas.MeasureValue(cmd.Label, cmd.Value)
		})
	}
}

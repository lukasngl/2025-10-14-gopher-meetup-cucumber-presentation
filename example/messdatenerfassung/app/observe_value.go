package app

import (
	"context"

	"example.invalid/domain/measurement"
	"example.invalid/domain/template"
)

// ObserveValueCommand represents a command to record a measured value.
type ObserveValueCommand struct {
	MeasurementID int
	Label         template.Label
	Value         float64
}

// ObserveValueHandler handles the ObserveValue command.
type ObserveValueHandler = CommandHandler[ObserveValueCommand]

// NewObserveValueHandler creates a new handler for recording measured values.
// The handler checks tolerances and may automatically transition the measurement
// to IN_SPEC or OUT_OF_SPEC status.
func NewObserveValueHandler(repo measurement.Repository) CommandHandler[ObserveValueCommand] {
	return func(ctx context.Context, cmd ObserveValueCommand) error {
		return repo.Update(ctx, cmd.MeasurementID, func(meas *measurement.Measurement) error {
			return meas.ObserveValue(cmd.Label, cmd.Value)
		})
	}
}

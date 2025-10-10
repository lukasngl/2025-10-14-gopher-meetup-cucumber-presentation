package measurement

import (
	"context"

	"example.invalid/domain/template"
)

// Repository defines the persistence interface for Measurement aggregates.
type Repository interface {
	// Create creates a new measurement and returns its ID
	Create(ctx context.Context, measurement Measurement) (int, error)
	// Read returns the measurement with the given ID
	Read(ctx context.Context, id int) (Measurement, error)
	// Update updates an existing measurement
	Update(ctx context.Context, id int, updateFn func(measurement *Measurement) error) error
	// ListByTemplate returns all measurements for a specific template
	ListByTemplate(ctx context.Context, templateID template.ID) ([]Measurement, error)
}

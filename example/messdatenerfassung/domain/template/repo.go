package template

import "context"

// Repository defines the persistence interface for Template aggregates.
type Repository interface {
	// Create stores a new template
	Create(ctx context.Context, template Template) error
	// Read returns the template with the given ID
	Read(ctx context.Context, id ID) (Template, error)
	// List returns all templates
	List(ctx context.Context) ([]Template, error)
}

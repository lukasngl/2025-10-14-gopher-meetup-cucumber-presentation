package app

import (
	"context"

	"example.invalid/domain/template"
)

// CreateTemplate represents a command to create a new measurement template.
type CreateTemplate struct {
	ID         template.ID
	Dimensions []template.Dimension
}

// CreateTemplateHandler handles the CreateTemplate command.
type CreateTemplateHandler = CommandHandler[CreateTemplate]

// NewCreateTemplateHandler creates a new handler for creating measurement templates.
// The handler validates the template through domain logic and persists it.
func NewCreateTemplateHandler(repo template.Repository) CommandHandler[CreateTemplate] {
	return func(ctx context.Context, cmd CreateTemplate) error {
		// Create template (domain logic validates)
		tmpl, err := template.New(cmd.ID, cmd.Dimensions)
		if err != nil {
			return err
		}

		// Persist
		return repo.Create(ctx, tmpl)
	}
}

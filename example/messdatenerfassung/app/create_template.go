package app

import (
	"context"

	"example.invalid/domain/template"
)

// CreateTemplateCommand represents a command to create a new measurement template.
type CreateTemplateCommand struct {
	ID         template.ID
	Dimensions []template.Dimension
}

// CreateTemplateHandler handles the CreateTemplate command.
type CreateTemplateHandler = CommandHandler[CreateTemplateCommand]

// NewCreateTemplateHandler creates a new handler for creating measurement templates.
// The handler validates the template through domain logic and persists it.
func NewCreateTemplateHandler(repo template.Repository) CommandHandler[CreateTemplateCommand] {
	return func(ctx context.Context, cmd CreateTemplateCommand) error {
		// Create template (domain logic validates)
		tmpl, err := template.New(cmd.ID, cmd.Dimensions)
		if err != nil {
			return err
		}

		// Persist
		return repo.Create(ctx, tmpl)
	}
}

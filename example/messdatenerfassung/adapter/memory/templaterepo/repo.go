// Package templaterepo provides an in-memory implementation of the template repository.
package templaterepo

import (
	"context"
	"fmt"
	"sync"

	"example.invalid/domain/template"
)

type repo struct {
	mu        sync.RWMutex
	templates map[string]template.Template
}

// New creates a new in-memory template repository.
func New() template.Repository {
	return &repo{
		templates: make(map[string]template.Template),
	}
}

func (r *repo) Create(ctx context.Context, tmpl template.Template) error {
	r.mu.Lock()
	defer r.mu.Unlock()

	id := tmpl.ID().String()
	if _, exists := r.templates[id]; exists {
		return fmt.Errorf("messvorlage mit ID %q existiert bereits", id)
	}

	r.templates[id] = tmpl
	return nil
}

func (r *repo) Read(ctx context.Context, id template.ID) (template.Template, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()

	tmpl, exists := r.templates[id.String()]
	if !exists {
		return template.Template{}, fmt.Errorf("messvorlage nicht gefunden")
	}

	return tmpl, nil
}

func (r *repo) List(ctx context.Context) ([]template.Template, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()

	templates := make([]template.Template, 0, len(r.templates))
	for _, tmpl := range r.templates {
		templates = append(templates, tmpl)
	}

	return templates, nil
}

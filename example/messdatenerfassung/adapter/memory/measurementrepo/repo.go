// Package measurementrepo provides an in-memory implementation of the measurement repository.
package measurementrepo

import (
	"context"
	"fmt"
	"sync"

	"example.invalid/domain/measurement"
	"example.invalid/domain/template"
)

type repo struct {
	mu           sync.RWMutex
	measurements map[int]measurement.Measurement
	nextID       int
}

// New creates a new in-memory measurement repository.
func New() measurement.Repository {
	return &repo{
		measurements: make(map[int]measurement.Measurement),
		nextID:       1,
	}
}

func (r *repo) Create(ctx context.Context, meas measurement.Measurement) (int, error) {
	r.mu.Lock()
	defer r.mu.Unlock()

	id := r.nextID
	r.nextID++

	// Create new measurement with assigned ID
	newMeas := measurement.New(id, meas.Template())
	r.measurements[id] = newMeas

	return id, nil
}

func (r *repo) Read(ctx context.Context, id int) (measurement.Measurement, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()

	meas, exists := r.measurements[id]
	if !exists {
		return measurement.Measurement{}, fmt.Errorf("messung nicht gefunden")
	}

	return meas, nil
}

func (r *repo) Update(ctx context.Context, id int, updateFn func(meas *measurement.Measurement) error) error {
	r.mu.Lock()
	defer r.mu.Unlock()

	meas, exists := r.measurements[id]
	if !exists {
		return fmt.Errorf("messung nicht gefunden")
	}

	if err := updateFn(&meas); err != nil {
		return err
	}

	r.measurements[id] = meas
	return nil
}

func (r *repo) ListByTemplate(ctx context.Context, templateID template.ID) ([]measurement.Measurement, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()

	measurements := make([]measurement.Measurement, 0)
	for _, meas := range r.measurements {
		if meas.Template().ID().String() == templateID.String() {
			measurements = append(measurements, meas)
		}
	}

	return measurements, nil
}

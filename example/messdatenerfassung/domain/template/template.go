// Package template provides the measurement template domain model.
// Templates define which dimensions must be measured for a given part,
// including tolerances for each dimension.
package template

import "fmt"

// Template represents an immutable measurement template that defines
// the dimensions that must be measured for a specific part type.
// Once created, templates cannot be modified.
type Template struct {
	id         ID
	dimensions []Dimension
}

// New creates a new immutable template with the given ID and dimensions
func New(id ID, dimensions []Dimension) (Template, error) {
	if len(dimensions) == 0 {
		return Template{}, fmt.Errorf("messvorlage muss mindestens eine Dimension haben")
	}

	// Validate all dimensions
	for _, dim := range dimensions {
		if err := dim.Validate(); err != nil {
			return Template{}, err
		}
	}

	// Check for duplicate dimension labels
	seen := make(map[string]bool)
	for _, dim := range dimensions {
		label := dim.Label.String()
		if seen[label] {
			return Template{}, fmt.Errorf("dimension %q ist mehrfach vorhanden", label)
		}
		seen[label] = true
	}

	return Template{
		id:         id,
		dimensions: dimensions,
	}, nil
}

// ID returns the template ID
func (t Template) ID() ID {
	return t.id
}

// Dimensions returns a copy of the dimensions slice
func (t Template) Dimensions() []Dimension {
	return append([]Dimension(nil), t.dimensions...)
}

// GetDimension returns the dimension with the given label
func (t Template) GetDimension(label Label) (Dimension, error) {
	for _, dim := range t.dimensions {
		if dim.Label.String() == label.String() {
			return dim, nil
		}
	}
	return Dimension{}, fmt.Errorf("dimension nicht in Messvorlage vorhanden")
}

// InSpec checks if a value for a given dimension is within spec
func (t Template) InSpec(label Label, value float64) (bool, error) {
	dim, err := t.GetDimension(label)
	if err != nil {
		return false, err
	}
	return dim.InSpec(value), nil
}

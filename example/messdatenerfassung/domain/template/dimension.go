package template

import (
	"fmt"

	"example.invalid/domain/unit"
)

// Label uniquely identifies a Dimension within a measurement template.
// Examples: "Durchmesser", "Stegbreite", "Innen Radius"
type Label struct{ string }

// NewLabel creates a new Label from a string.
func NewLabel(s string) (Label, error) {
	//TODO: validate label (e.g., non-empty, max length)
	return Label{s}, nil
}

// String returns the string representation of the label.
func (l Label) String() string {
	return l.string
}

// Dimension represents a measurable dimension with its tolerances.
// It defines what needs to be measured (Label), the measurement unit,
// the nominal value, and acceptable tolerance range (Lower to Upper).
type Dimension struct {
	Label   Label      // Name of the dimension (e.g., "Durchmesser")
	Unit    unit.Unit  // Unit of measurement (e.g., "mm")
	Nominal float64    // Target/nominal value
	Upper   float64    // Upper tolerance limit (inclusive)
	Lower   float64    // Lower tolerance limit (inclusive)
}

// Validate checks if the dimension has valid tolerances
func (d Dimension) Validate() error {
	if d.Lower > d.Upper {
		return fmt.Errorf("untere Toleranz muss kleiner als obere Toleranz sein")
	}
	if d.Label.String() == "" {
		return fmt.Errorf("dimension muss einen Namen haben")
	}
	return nil
}

// InSpec checks if a value is within the tolerance range
func (d Dimension) InSpec(value float64) bool {
	return value >= d.Lower && value <= d.Upper
}

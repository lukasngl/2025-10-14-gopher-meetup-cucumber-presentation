// Package unit provides measurement units for dimensions.
package unit

// Unit represents a unit of measurement (e.g., millimeters, degrees).
type Unit struct{ string }

// NewUnit creates a new Unit from a string.
func NewUnit(s string) (Unit, error) {
	// TODO: validate unit (e.g., check against allowed units)
	return Unit{s}, nil
}

// String returns the string representation of the unit.
func (u Unit) String() string {
	return u.string
}

var (
	// Invalid represents an uninitialized unit
	Invalid = Unit{}
	// Millimeters represents millimeter measurements
	Millimeters = Unit{"mm"}
	// Meters represents meter measurements
	Meters = Unit{"meters"}
	// Degrees represents angular degree measurements
	Degrees = Unit{"degrees"}
)

package template

import (
	"fmt"
	"regexp"
)

// ID is the identifier for a measurement template.
// It must match the pattern ^MV\d{7}$ (e.g., "MV0001234").
type ID struct{ string }

// NewID creates a new template ID and validates it against the required pattern.
func NewID(value string) (ID, error) {
	id := ID{value}
	return id, id.IsValid()
}

// String returns the string representation of the template ID.
func (id ID) String() string {
	return id.string
}

// IsValid checks if the ID matches the required pattern ^MV\d{7}$.
func (id ID) IsValid() error {
	if id.String() == "" {
		return fmt.Errorf("id must not be empty")
	}

	if !idPat.MatchString(id.String()) {
		return fmt.Errorf("id must match pattern %q", idPat.String())
	}

	return nil
}

var idPat = regexp.MustCompile(`^MV\d{7}$`)

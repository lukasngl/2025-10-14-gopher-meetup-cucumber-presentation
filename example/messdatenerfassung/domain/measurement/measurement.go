// Package measurement provides the measurement domain model.
// A measurement tracks the actual measured values for a part based on a template,
// automatically determining if the part is dimensionally accurate (maßhaltig).
package measurement

import (
	"fmt"
	"time"

	"example.invalid/domain/template"
)

// Measurement represents a measurement session for a specific part.
// It tracks observed values for each dimension and automatically
// transitions between states (PENDING, IN_SPEC, OUT_OF_SPEC).
type Measurement struct {
	id int

	template   template.Template
	measValues []Value
	status     Status
	startedAt  time.Time
	finishedAt *time.Time
}

// Value represents a single measured value for a dimension,
// including whether it falls within the specified tolerances.
type Value struct {
	value          float64
	inSpec         bool
	dimensionLabel template.Label
}

// Status represents the current state of a measurement.
type Status struct{ string }

// String returns the string representation of the status.
func (s Status) String() string {
	return s.string
}

var (
	// StatusInvalid represents an uninitialized status
	StatusInvalid = Status{}
	// StatusPending indicates not all dimensions have been measured yet
	StatusPending = Status{"PENDING"}
	// StatusInSpec indicates all dimensions measured and within tolerances (maßhaltig)
	StatusInSpec = Status{"IN_SPEC"}
	// StatusOutOfSpec indicates at least one dimension is outside tolerances (nicht maßhaltig)
	StatusOutOfSpec = Status{"OUT_OF_SPEC"}
)

// New creates a new measurement from a template
func New(id int, tmpl template.Template) Measurement {
	return Measurement{
		id:         id,
		template:   tmpl,
		measValues: []Value{},
		status:     StatusPending,
		startedAt:  time.Now(),
	}
}

// MeasureValue records a measured value for a dimension
// Business rules:
// - Cannot observe after measurement is finished
// - Cannot observe dimension not in template
// - Cannot observe same dimension twice
// - Any out-of-spec value → OUT_OF_SPEC (finished)
// - All dimensions measured + all in spec → IN_SPEC (finished)
func (meas *Measurement) MeasureValue(
	label template.Label,
	value float64,
) error {
	// Check if measurement is already finished
	if meas.IsFinished() {
		return fmt.Errorf("messung bereits abgeschlossen")
	}

	// Check if dimension already measured
	if meas.hasMeasuredDimension(label) {
		return fmt.Errorf("dimension bereits gemessen")
	}

	// Check if dimension exists in template and if value is in spec
	inSpec, err := meas.template.InSpec(label, value)
	if err != nil {
		return err
	}

	// Record the value
	meas.measValues = append(meas.measValues, Value{
		value:          value,
		inSpec:         inSpec,
		dimensionLabel: label,
	})

	// Update status based on business rules
	if !inSpec {
		// Any out-of-spec value → OUT_OF_SPEC (finished)
		meas.status = StatusOutOfSpec
		now := time.Now()
		meas.finishedAt = &now
	} else if meas.allDimensionsMeasured() {
		// All dimensions measured + all in spec → IN_SPEC (finished)
		meas.status = StatusInSpec
		now := time.Now()
		meas.finishedAt = &now
	}

	return nil
}

// hasMeasuredDimension checks if a dimension has already been measured
func (meas *Measurement) hasMeasuredDimension(label template.Label) bool {
	for _, val := range meas.measValues {
		if val.dimensionLabel.String() == label.String() {
			return true
		}
	}
	return false
}

// allDimensionsMeasured checks if all dimensions from the template have been measured
func (meas *Measurement) allDimensionsMeasured() bool {
	return len(meas.measValues) == len(meas.template.Dimensions())
}

// IsFinished returns true if the measurement is finished (has finishedAt timestamp)
func (meas Measurement) IsFinished() bool {
	return meas.finishedAt != nil
}

// IsDimensionallyAccurate returns true if all measurements are within spec (maßhaltig)
func (meas Measurement) IsDimensionallyAccurate() bool {
	return meas.status == StatusInSpec
}

// Template returns the measurement template
func (meas Measurement) Template() template.Template {
	return meas.template
}

// Values returns a copy of the measured values
func (meas Measurement) Values() []Value {
	return append([]Value(nil), meas.measValues...)
}

// Status returns the current measurement status
func (meas Measurement) Status() Status {
	return meas.status
}

// Value getters
func (v Value) Value() float64 {
	return v.value
}

func (v Value) InSpec() bool {
	return v.inSpec
}

func (v Value) DimensionLabel() template.Label {
	return v.dimensionLabel
}

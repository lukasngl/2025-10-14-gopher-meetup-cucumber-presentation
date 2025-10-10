package app

import (
	"context"

	"example.invalid/domain/measurement"
)

// GetMeasurementStatusQuery represents a query for measurement status.
type GetMeasurementStatusQuery struct {
	MeasurementID int
}

// MeasurementStatusResult contains the status of a measurement.
type MeasurementStatusResult struct {
	IsFinished              bool // Whether all dimensions have been measured
	IsDimensionallyAccurate bool // Whether the part is maßhaltig (within tolerances)
	TotalDimensions         int  // Total number of dimensions in the template
	MeasuredDimensions      int  // Number of dimensions measured so far
	Values                  []MeasuredValue
}

// MeasuredValue represents a single measured value with its status.
type MeasuredValue struct {
	DimensionLabel string
	Value          float64
	InSpec         bool // Whether this value is within tolerance
}

// GetMeasurementStatusHandler handles the GetMeasurementStatus query.
type GetMeasurementStatusHandler = QueryHandler[GetMeasurementStatusQuery, MeasurementStatusResult]

// NewGetMeasurementStatusHandler creates a new handler for querying measurement status.
func NewGetMeasurementStatusHandler(repo measurement.Repository) QueryHandler[GetMeasurementStatusQuery, MeasurementStatusResult] {
	return func(ctx context.Context, qry GetMeasurementStatusQuery) (MeasurementStatusResult, error) {
		meas, err := repo.Read(ctx, qry.MeasurementID)
		if err != nil {
			return MeasurementStatusResult{}, err
		}

		values := make([]MeasuredValue, 0, len(meas.Values()))
		for _, v := range meas.Values() {
			values = append(values, MeasuredValue{
				DimensionLabel: v.DimensionLabel().String(),
				Value:          v.Value(),
				InSpec:         v.InSpec(),
			})
		}

		return MeasurementStatusResult{
			IsFinished:              meas.IsFinished(),
			IsDimensionallyAccurate: meas.IsDimensionallyAccurate(),
			TotalDimensions:         len(meas.Template().Dimensions()),
			MeasuredDimensions:      len(meas.Values()),
			Values:                  values,
		}, nil
	}
}

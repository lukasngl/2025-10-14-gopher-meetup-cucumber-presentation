package app

import (
	"context"

	"example.invalid/domain/template"
)

// GetTemplateDetails represents a query for template details.
type GetTemplateDetails struct {
	TemplateID template.ID
}

// TemplateDetailsResult contains the details of a measurement template.
type TemplateDetailsResult struct {
	ID         string
	Dimensions []DimensionDetails
}

// DimensionDetails represents the details of a dimension in a template.
type DimensionDetails struct {
	Label          string
	Unit           string
	Nominal        float64
	LowerTolerance float64
	UpperTolerance float64
}

// GetTemplateDetailsHandler handles the GetTemplateDetails query.
type GetTemplateDetailsHandler = QueryHandler[GetTemplateDetails, TemplateDetailsResult]

// NewGetTemplateDetailsHandler creates a new handler for querying template details.
func NewGetTemplateDetailsHandler(
	repo template.Repository,
) QueryHandler[GetTemplateDetails, TemplateDetailsResult] {
	return func(ctx context.Context, qry GetTemplateDetails) (TemplateDetailsResult, error) {
		tmpl, err := repo.Read(ctx, qry.TemplateID)
		if err != nil {
			return TemplateDetailsResult{}, err
		}

		dims := make([]DimensionDetails, 0, len(tmpl.Dimensions()))
		for _, d := range tmpl.Dimensions() {
			dims = append(dims, DimensionDetails{
				Label:          d.Label.String(),
				Unit:           d.Unit.String(),
				Nominal:        d.Nominal,
				LowerTolerance: d.Lower,
				UpperTolerance: d.Upper,
			})
		}

		return TemplateDetailsResult{
			ID:         tmpl.ID().String(),
			Dimensions: dims,
		}, nil
	}
}

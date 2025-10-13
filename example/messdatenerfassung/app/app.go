// Package app provides the application layer using the CQRS pattern.
// It contains command handlers (state-changing operations) and query handlers
// (read-only operations) for the measurement system.
package app

import (
	"context"
	"fmt"
	"log/slog"
	"sync/atomic"

	"example.invalid/domain/measurement"
	"example.invalid/domain/template"
)

// CommandHandler is a generic handler for state-changing commands.
// Commands do not return data, only errors.
type CommandHandler[C any] func(ctx context.Context, cmd C) error

// QueryHandler is a generic handler for read-only queries.
// Queries return data and errors.
type QueryHandler[Q, R any] func(ctx context.Context, qry Q) (R, error)

// App contains all command and query handlers for the measurement application.
type App struct {
	// Commands
	CreateTemplate   CreateTemplateHandler
	StartMeasurement StartMeasurementHandler
	ObserveValue     MeasureValueHandler

	// Queries
	GetMeasurementStatus GetMeasurementStatusHandler
	GetTemplateDetails   GetTemplateDetailsHandler
}

// New creates a new application with all handlers wired up.
// Handlers are decorated with logging for observability.
func New(templateRepo template.Repository, measurementRepo measurement.Repository) *App {
	return &App{
		// Commands with logging
		CreateTemplate: LogCommandHandler(NewCreateTemplateHandler(templateRepo)),
		ObserveValue:   LogCommandHandler(NewObserveValueHandler(measurementRepo)),

		// StartMeasurement returns an ID, so it's technically a query (CQRS purists would disagree, but this is pragmatic)
		StartMeasurement: LogQueryHandler(
			NewStartMeasurementHandler(templateRepo, measurementRepo),
		),

		// Queries with logging
		GetMeasurementStatus: LogQueryHandler(NewGetMeasurementStatusHandler(measurementRepo)),
		GetTemplateDetails:   LogQueryHandler(NewGetTemplateDetailsHandler(templateRepo)),
	}
}

// === Decorators

func LogCommandHandler[C any](h CommandHandler[C]) CommandHandler[C] {
	var seq atomic.Int64 // helper to correlate log lines

	return func(ctx context.Context, cmd C) (err error) {
		slog := slog.Default().With(
			"command", fmt.Sprintf("%T", cmd),
			"seq", seq.Add(1),
		)
		slog.Debug("handling command", "body", cmd)
		defer func() {
			if err == nil {
				slog.Debug("command handled successfully")
			} else {
				slog.Debug("command handling failed", "error", err)
			}
		}()

		return h(ctx, cmd)
	}
}

func LogQueryHandler[Q, R any](h QueryHandler[Q, R]) QueryHandler[Q, R] {
	var seq atomic.Int64 // helper to correlate log lines

	return func(ctx context.Context, qry Q) (res R, err error) {
		slog := slog.Default().With(
			"query", fmt.Sprintf("%T", qry),
			"seq", seq.Add(1),
		)
		slog.Debug("handling query", "body", qry)
		defer func() {
			if err == nil {
				slog.Debug("query handled successfully", "result", res)
			} else {
				slog.Debug("query handling failed", "error", err)
			}
		}()

		return h(ctx, qry)
	}
}

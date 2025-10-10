// Package testsuite provides test infrastructure for Cucumber/Godog tests.
package testsuite

import (
	"context"
	"fmt"

	"example.invalid/app"
)

// SzenarioState is the state that is created for each scenario.
// It holds the application instance and test state across step definitions.
type SzenarioState struct {
	App *app.App

	// State to track entities created during test
	LastError         error
	LastTemplateID    string
	LastMeasurementID int
}

// Get retrieves the scenario state from the context, panicking if not found.
func Get(ctx context.Context) *SzenarioState {
	state, err := TryGet(ctx)
	if err != nil {
		panic(err.Error())
	}

	return state
}

// WithSzenarioState adds the scenario state to the context.
func WithSzenarioState(ctx context.Context, state *SzenarioState) context.Context {
	return context.WithValue(ctx, scenarioCtxKey{}, state)
}

// TryGet attempts to retrieve the scenario state from the context, returning an error if not found.
func TryGet(ctx context.Context) (*SzenarioState, error) {
	value := ctx.Value(scenarioCtxKey{})
	if value == nil {
		return nil, fmt.Errorf("szenario state not set")
	}

	state, ok := value.(*SzenarioState)
	if !ok {
		return nil, fmt.Errorf("expected *SzenarioState but got %T", state)
	}

	return state, nil
}

type scenarioCtxKey struct{}

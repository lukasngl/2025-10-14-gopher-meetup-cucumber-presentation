// Package testsuite provides test infrastructure for Cucumber/Godog tests.
package testsuite

import (
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

	// scenarioPool is the database connection pool for this specific scenario
	// (only used in integration tests with database isolation)
	scenarioPool any // *pgxpool.Pool, but we use any to avoid import cycle
}

package testsuite

import (
	"context"

	"example.invalid/adapter/memory/measurementrepo"
	"example.invalid/adapter/memory/templaterepo"
	"example.invalid/app"
	"github.com/cucumber/godog"
)

func InitHandlerTest(tsc *godog.TestSuiteContext) {
	sc := tsc.ScenarioContext()

	sc.Before(func(ctx context.Context, sc *godog.Scenario) (context.Context, error) {
		state := &SzenarioState{
			App: app.New(
				templaterepo.New(),
				measurementrepo.New(),
			),
		}

		return WithSzenarioState(ctx, state), nil
	})
}

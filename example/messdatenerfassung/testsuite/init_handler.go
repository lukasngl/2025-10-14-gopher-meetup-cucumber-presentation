package testsuite

import (
	"example.invalid/adapter/memory/measurementrepo"
	"example.invalid/adapter/memory/templaterepo"
	"example.invalid/app"
	"github.com/cucumber/godog"
)

func InitHandlerTest(sc *godog.ScenarioContext) {
	state := &SzenarioState{
		App: app.New(
			templaterepo.New(),
			measurementrepo.New(),
		),
	}
	InitializeSteps(sc, state)
}

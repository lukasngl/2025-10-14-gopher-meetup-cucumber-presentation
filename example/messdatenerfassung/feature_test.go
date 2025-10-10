package main_test

import (
	"flag"
	"strings"
	"testing"

	"example.invalid/testsuite"

	"github.com/cucumber/godog"
)

// featureSpec allows you to run specific feature/scenarios by
// specifying <file>[:<line>], e.g.:
//
//	go test -v . -godog.feature ./features/create_template.feature
//
// Note that the line if given must contain the 'Szenario:'.
var featureSpec = flag.String(
	"godog.feature",
	"./features",
	"features to run, can be path to a directory or a file[:line]",
)

// TestHandler runs the feature tests with in-memory storage.
// This provides fast feedback during development.
func TestHandler(t *testing.T) {
	suite := godog.TestSuite{
		TestSuiteInitializer: testsuite.InitHandlerTest,
		Options: &godog.Options{
			Format:   "pretty",
			Paths:    strings.Split(*featureSpec, ","),
			TestingT: t,    // Testing instance that will run subtests.
			Strict:   true, // Fail if a step is not defined.
		},
	}

	if suite.Run() != 0 {
		t.Fatal("non-zero status returned, failed to run feature tests")
	}
}

// TestIntegration runs the feature tests with PostgreSQL testcontainer for integration testing.
// It provides production-like testing with real database transactions and concurrency handling.
func TestIntegration(t *testing.T) {
	if testing.Short() {
		t.Skip("skipping integration tests in short mode")
	}

	suite := godog.TestSuite{
		TestSuiteInitializer: testsuite.InitIntegrationTest,
		Options: &godog.Options{
			Format:   "pretty",
			Paths:    strings.Split(*featureSpec, ","),
			TestingT: t,    // Testing instance that will run subtests.
			Strict:   true, // Fail if a step is not defined.
		},
	}

	if suite.Run() != 0 {
		t.Fatal("non-zero status returned, failed to run feature tests")
	}
}

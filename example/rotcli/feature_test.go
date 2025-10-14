package main_test

import (
	"bytes"
	"context"
	"flag"
	"fmt"
	"strings"
	"testing"

	"example.invalid/rotcli/cmd"
	"github.com/cucumber/godog"
	"github.com/google/go-cmp/cmp"
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

func TestFeature(t *testing.T) {
	suite := godog.TestSuite{
		ScenarioInitializer: func(sc *godog.ScenarioContext) {
			var output *bytes.Buffer

			sc.When(
				`^I run rotcli with shift value (\d+) and input:$`,
				func(rot int, input *godog.DocString) error {
					return cmd.Run(
						bytes.NewReader([]byte(input.Content)),
						output,
						rot,
					)
				},
			)

			sc.Then(
				"^the output should be:$",
				func(ctx context.Context, input *godog.DocString) error {
					actual := output.String()
					expected := input.Content
					if diff := cmp.Diff(actual, expected); diff != "" {
						return fmt.Errorf("output mismatch: %s", diff)
					}
					return nil
				},
			)
		},
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

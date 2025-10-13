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
		TestSuiteInitializer: func(tsc *godog.TestSuiteContext) {
			type ctxKey struct{}

			tsc.ScenarioContext().When(
				`^I run rotcli with shift value (\d+) and input:$`,
				func(ctx context.Context, rot int, input *godog.DocString) (context.Context, error) {
					output := bytes.NewBuffer(nil)

					err := cmd.Run(
						bytes.NewReader([]byte(input.Content)),
						output,
						rot,
					)
					if err != nil {
						return ctx, err
					}

					return context.WithValue(ctx, ctxKey{}, output.Bytes()), nil
				},
			)

			tsc.ScenarioContext().Then(
				"^the output should be:$",
				func(ctx context.Context, input *godog.DocString) error {
					actual := string(ctx.Value(ctxKey{}).([]byte))
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

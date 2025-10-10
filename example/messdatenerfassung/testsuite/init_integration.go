package testsuite

import (
	"context"
	"errors"
	"testing"
	"time"

	"example.invalid/adapter/sql/measurementrepo"
	"example.invalid/adapter/sql/templaterepo"
	"example.invalid/app"

	"github.com/cucumber/godog"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/testcontainers/testcontainers-go"
	"github.com/testcontainers/testcontainers-go/modules/postgres"
)

// InitIntegrationTest initializes integration tests with a real PostgreSQL database.
// Uses testcontainers to spin up a PostgreSQL instance for testing.
func InitIntegrationTest(t *testing.T, tsc *godog.TestSuiteContext) {
	ctx := t.Context()

	var pool *pgxpool.Pool
	var testContainer *postgres.PostgresContainer

	tsc.ScenarioContext().
		Before(func(ctx context.Context, sc *godog.Scenario) (context.Context, error) {
			// Create SQL repositories
			templateRepo := templaterepo.New(pool)
			measurementRepo := measurementrepo.New(pool, templateRepo)

			state := &SzenarioState{
				App: app.New(templateRepo, measurementRepo),
			}

			return WithSzenarioState(ctx, state), nil
		})

	tsc.BeforeSuite(func() {
		var err error

		startCtx, cancel := context.WithTimeout(ctx, 30*time.Second)
		defer cancel()

		testContainer, err = postgres.Run(startCtx, "postgres:17-alpine",
			postgres.WithDatabase("test"),
			postgres.WithUsername("user"),
			postgres.WithPassword("password"),
			postgres.BasicWaitStrategies(),
			// Store database in tmpfs (i.e. in memory) to make postgres go brrr
			testcontainers.WithEnv(map[string]string{"PGDATA": "/var/lib/postgresql/data"}),
			testcontainers.WithTmpfs(map[string]string{"/var/lib/postgresql/data": "rw"}),
		)
		if err != nil {
			t.Errorf("failed to start testcontainer: %v", err)
			return
		}

		dsn, err := testContainer.ConnectionString(ctx, "sslmode=disable")
		if err != nil {
			t.Errorf("failed to get connection string: %v", err)
			return
		}

		pool, err = pgxpool.New(ctx, dsn)
		if err != nil {
			t.Errorf("failed to create connection pool: %v", err)
			return
		}

		// Run migrations
		templateRepo := templaterepo.New(pool)
		if err := templateRepo.Migrate(ctx); err != nil {
			t.Errorf("failed to migrate templates: %v", err)
			return
		}

		measurementRepo := measurementrepo.New(pool, templateRepo)
		if err := measurementRepo.Migrate(ctx); err != nil {
			t.Errorf("failed to migrate measurements: %v", err)
			return
		}
	})

	tsc.AfterSuite(func() {
		var errs []error

		if pool != nil {
			pool.Close()
		}

		if testContainer != nil {
			errs = append(errs, testContainer.Stop(ctx, nil))
		}

		if err := errors.Join(errs...); err != nil {
			t.Errorf("failed to cleanup: %v", err)
		}
	})
}

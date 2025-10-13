package testsuite

import (
	"context"
	"errors"
	"fmt"
	"sync/atomic"
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
// Each scenario gets its own isolated database created from a template.
func InitIntegrationTest(t *testing.T, tsc *godog.TestSuiteContext) {
	ctx := t.Context()

	var adminPool *pgxpool.Pool
	var testContainer *postgres.PostgresContainer
	var scenarioCounter atomic.Int64

	sc := tsc.ScenarioContext()

	sc.Before(func(ctx context.Context, sc *godog.Scenario) (context.Context, error) {
		// Generate unique database name for this scenario
		scenarioPool, err := createSzenarioDB(
			ctx,
			testContainer,
			adminPool,
			scenarioCounter.Add(1),
		)
		if err != nil {
			return ctx, fmt.Errorf("failed to create scenario pool: %w", err)
		}

		// Create SQL repositories with scenario-specific pool
		templateRepo := templaterepo.New(scenarioPool)
		measurementRepo := measurementrepo.New(scenarioPool, templateRepo)

		state := &SzenarioState{
			App:          app.New(templateRepo, measurementRepo),
			scenarioPool: scenarioPool,
		}

		return WithSzenarioState(ctx, state), nil
	})

	tsc.BeforeSuite(func() {
		startCtx, cancel := context.WithTimeout(ctx, 30*time.Second)
		defer cancel()

		var err error
		testContainer, adminPool, err = setupContainerAndTemplateDB(startCtx)
		if err != nil {
			t.Errorf("failed to setup test environment: %v", err)
			return
		}
	})

	tsc.AfterSuite(func() {
		var errs []error

		if adminPool != nil {
			adminPool.Close()
		}

		if testContainer != nil {
			errs = append(errs, testContainer.Stop(ctx, nil))
		}

		if err := errors.Join(errs...); err != nil {
			t.Errorf("failed to cleanup: %v", err)
		}
	})
}

func createSzenarioDB(
	ctx context.Context,
	testContainer *postgres.PostgresContainer,
	adminPool *pgxpool.Pool,
	scenarioNum int64,
) (*pgxpool.Pool, error) {
	scenarioDB := fmt.Sprintf("scenario_%d", scenarioNum)

	// Create scenario-specific database from template
	_, err := adminPool.Exec(
		ctx,
		fmt.Sprintf("CREATE DATABASE %s TEMPLATE test_template", scenarioDB),
	)
	if err != nil {
		return nil, fmt.Errorf("failed to create scenario database: %w", err)
	}

	// Get connection string for scenario database
	dsn, err := testContainer.ConnectionString(ctx, "sslmode=disable", "dbname="+scenarioDB)
	if err != nil {
		return nil, fmt.Errorf("failed to get scenario connection string: %w", err)
	}

	// Create pool for scenario database
	scenarioPool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		return nil, fmt.Errorf("failed to create scenario pool: %w", err)
	}

	return scenarioPool, nil
}

func setupContainerAndTemplateDB(
	ctx context.Context,
) (*postgres.PostgresContainer, *pgxpool.Pool, error) {
	// Start PostgreSQL container with default postgres database
	testContainer, err := postgres.Run(ctx, "postgres:17-alpine",
		postgres.WithDatabase("postgres"),
		postgres.WithUsername("user"),
		postgres.WithPassword("password"),
		postgres.BasicWaitStrategies(),
		// Store database in tmpfs (i.e. in memory) to make postgres go brrr
		testcontainers.WithEnv(map[string]string{"PGDATA": "/var/lib/postgresql/data"}),
		testcontainers.WithTmpfs(map[string]string{"/var/lib/postgresql/data": "rw"}),
	)
	if err != nil {
		return nil, nil, fmt.Errorf("failed to start testcontainer: %w", err)
	}

	// Connect to postgres admin database
	adminDSN, err := testContainer.ConnectionString(ctx, "sslmode=disable")
	if err != nil {
		return nil, nil, fmt.Errorf("failed to get connection string: %w", err)
	}

	adminPool, err := pgxpool.New(ctx, adminDSN)
	if err != nil {
		return nil, nil, fmt.Errorf("failed to create admin connection pool: %w", err)
	}

	// Create template database
	_, err = adminPool.Exec(ctx, "CREATE DATABASE test_template")
	if err != nil {
		return nil, nil, fmt.Errorf("failed to create template database: %w", err)
	}

	// Connect to template database for migrations
	templateDSN, err := testContainer.ConnectionString(
		ctx,
		"sslmode=disable",
		"dbname=test_template",
	)
	if err != nil {
		return nil, nil, fmt.Errorf("failed to get template connection string: %w", err)
	}

	templatePool, err := pgxpool.New(ctx, templateDSN)
	if err != nil {
		return nil, nil, fmt.Errorf("failed to create template connection pool: %w", err)
	}
	defer templatePool.Close()

	// Run migrations on template database
	templateRepo := templaterepo.New(templatePool)
	if err := templateRepo.Migrate(ctx); err != nil {
		return nil, nil, fmt.Errorf("failed to migrate templates: %w", err)
	}

	measurementRepo := measurementrepo.New(templatePool, templateRepo)
	if err := measurementRepo.Migrate(ctx); err != nil {
		return nil, nil, fmt.Errorf("failed to migrate measurements: %w", err)
	}

	return testContainer, adminPool, nil
}

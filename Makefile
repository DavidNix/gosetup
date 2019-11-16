setup: build-tools

build-tools:
	@cat tools.go | grep _ | awk '{print $$2}' | xargs -n 1 go install

# Postgres Database Migrations
# Change db names here
DEVDB=egreedy_dev
TESTDB=egreedy_test

dbcreate:
	@createdb $(DEVDB)
	@createdb $(TESTDB)
	@psql $(DEVDB) -c "ALTER DATABASE $(DEVDB) SET timezone TO 'UTC'"
	@psql $(TESTDB) -c "ALTER DATABASE $(TESTDB) SET timezone TO 'UTC'"

dbdrop:
	@dropdb $(DEVDB)
	@dropdb $(TESTDB)

dbschema:
	@psql $(DEVDB) < migrations/schema.sql
	@psql $(DEVDB) < migrations/schema_migrations.sql
	@psql $(TESTDB) < migrations/schema.sql
	@psql $(TESTDB) < migrations/schema_migrations.sql

dbreset: dbdrop dbcreate dbschema

migrate-up:
	@migrate -path migrations/ -database postgres://localhost:5432/$(DEVDB)?sslmode=disable up
	@migrate -path migrations/ -database postgres://localhost:5432/$(TESTDB)?sslmode=disable up > /dev/null 2>&1
	@pg_dump -s --no-owner $(DEVDB) > ./migrations/schema.sql
	@pg_dump --data-only --no-owner -t schema_migrations $(DEVDB) > ./migrations/schema_migrations.sql

migrate-down:
	@migrate -path migrations/ -database postgres://localhost:5432/$(DEVDB)?sslmode=disable down
	@migrate -path migrations/ -database postgres://localhost:5432/$(TESTDB)?sslmode=disable down > /dev/null 2>&1
	@pg_dump -s --no-owner $(DEVDB) > ./migrations/schema.sql
	@pg_dump --data-only --no-owner -t schema_migrations $(DEVDB) > ./migrations/schema_migrations.sql


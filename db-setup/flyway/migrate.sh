export FLYWAY_URL="jdbc:postgresql://${POSTGRESQL_HOST}.postgres.database.azure.com:5432/${POSTGRESQL_DATABASE}?sslmode=require"
export FLYWAY_USER="${POSTGRESQL_USERNAME}"
export FLYWAY_PASSWORD="${POSTGRESQL_PASSWORD}"
export FLYWAY_BASELINE_ON_MIGRATE="true"

flyway migrate
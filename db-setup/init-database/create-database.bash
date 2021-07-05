#!/bin/sh
psql -v dbname="${POSTGRESQL_DATABASE}" "host=${POSTGRESQL_HOST}.postgres.database.azure.com port=5432 dbname=postgres user=${POSTGRESQL_USERNAME} password=${POSTGRESQL_PASSWORD} sslmode=require" -f create-database.sql

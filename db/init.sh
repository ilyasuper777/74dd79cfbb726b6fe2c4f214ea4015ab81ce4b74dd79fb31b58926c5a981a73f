#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$DB_USER" --dbname "$DB_DATABASE" <<-EOSQL
    ALTER USER "$DB_USER" WITH PASSWORD '$DB_PASSWORD';
    CREATE ROLE $DB_REPL_USER WITH REPLICATION LOGIN PASSWORD '$DB_REPL_PASSWORD';
    CREATE TABLE emails (id serial PRIMARY KEY, Value VARCHAR(50));
    CREATE TABLE PhoneNumbers (id serial PRIMARY KEY, Value VARCHAR(30));
    INSERT INTO PhoneNumbers (Value) VALUES ('84957440144');
    INSERT INTO emails (Value) VALUES ('PT@PT.ru');
EOSQL

echo "host replication ${DB_REPL_USER} ${DB_REPL_HOST}/16 md5" >> /var/lib/postgresql/data/pg_hba.conf

exec "$@"
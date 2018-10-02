FROM jbergknoff/postgresql-client

COPY import.sql /import.sql

ENTRYPOINT psql -h shared-database-v10 -d idam -U postgres < /import.sql

{% macro store_tests_summary(use_prod_source=true) %}
{% if use_prod_source %}
    {% set table_schema = "prod_dbt_test__audit" %}
{% else %}
    {% set table_schema = schema ~ "_dbt_test__audit" %}
{% endif %}
{% set target_schema = schema ~ "_audit" %}
{% set sql %}
-- Create the table if necessary
create table if not exists {{ target_schema }}.test_results
(
    source_database    varchar(100),
    table_schema       varchar(100),
    test_alias         varchar(200),
    row_count          number(10,0),
    created_timestamp  timestamp_ntz
)
;

-- Get any test results not already in the table
insert into {{ target_schema }}.test_results (
    source_database,
    table_schema,
    test_alias,
    row_count,
    created_timestamp
)
select
    lower(table_catalog),
    lower(table_schema),
    lower(table_name),
    row_count,
    created::timestamp_ntz
from
    information_schema.tables
where
    lower(table_schema) = '{{ table_schema }}'
    and created::timestamp_ntz > coalesce(
        (
            select
                max(created_timestamp)
            from
                {{ target_schema }}.test_results
        ),
        '1900-01-01'
    )
;
{% endset %}
-- Create the schema if we need to
{% do adapter.create_schema(api.Relation.create(database=target.database, schema=target_schema)) %}

-- Run the SQL query
{% do run_query(sql) %}
{% endmacro %}

{% macro generate_sources_yaml(
    schema_names=[],
    database_name=target.database,
    generate_columns=False,
    include_descriptions=False,
    skip=False
) %}

{% if not skip %}

{% set sources_yaml=[] %}

{% do sources_yaml.append('version: 2') %}
{% do sources_yaml.append('') %}
{% do sources_yaml.append('sources:') %}

{% for schema_name in schema_names %}

    {% do sources_yaml.append('  - name: ' ~ schema_name | lower) %}

    {% if database_name != target.database %}
        {% do sources_yaml.append('    database: ' ~ database_name | lower) %}
        {% endif %}

        {% do sources_yaml.append('    tables:') %}

        {% set tables=codegen.get_tables_in_schema(schema_name, database_name) %}

        {% for table in tables %}
            {% do sources_yaml.append('      - name: ' ~ table | lower ) %}

            {% if generate_columns %}
            {% do sources_yaml.append('        columns:') %}

                {% set table_relation=api.Relation.create(
                    database=database_name,
                    schema=schema_name,
                    identifier=table
                ) %}

                {% set columns=adapter.get_columns_in_relation(table_relation) %}

                {% for column in columns %}
                    {% do sources_yaml.append('          - name: ' ~ column.name | lower ) %}
                    {% if include_descriptions %}
                        {% do sources_yaml.append('            description: ""' ) %}
                    {% endif %}
                {% endfor %}
                    {% do sources_yaml.append('') %}

            {% endif %}

        {% endfor %}

{% endfor %}

{% if execute %}

    {% set joined = sources_yaml | join ('\n') %}
    {{ log(joined, info=True) }}
    {% do return(joined) %}

{% endif %}

{% endif %}

{% endmacro %}

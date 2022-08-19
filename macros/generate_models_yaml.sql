{% macro generate_models_yaml(model_names=[], include_description=false) %}

{% set model_yaml=[] %}

{% do model_yaml.append('version: 2') %}
{% do model_yaml.append('') %}
{% do model_yaml.append('models:') %}

{% for model_name in model_names %}

    {% do model_yaml.append('') %}
    {% do model_yaml.append('  - name: ' ~ model_name | lower) %}
    {% do model_yaml.append('    description: ""') %}
    {% do model_yaml.append('    columns:') %}
    {% set relation=ref(model_name) %}
    {%- set columns = adapter.get_columns_in_relation(relation) -%}

    {% for column in columns %}
        {% do model_yaml.append('      - name: ' ~ column.name | lower ) %}
        {%- if include_description -%}
        {% do model_yaml.append('        description: ""') %}
        {%- endif -%}
    {% endfor %}

{% endfor %}

{% do model_yaml.append('') %}

{% if execute %}

    {% set joined = model_yaml | join ('\n') %}
    {{ log(joined, info=True) }}
    {% do return(joined) %}

{% endif %}

{% endmacro %}
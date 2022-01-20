{% macro get_test_details() %}
{%- set tests = dict() -%}
{%- for key, test in graph.nodes.items() -%}
    {%- if key.startswith("test." ~ project_name) -%}
    {%- do tests.update({key: test}) %}
    {%- endif -%}
{%- endfor -%}
select
    test_name,
    test_alias,
    test_type_name,
    model_name,
    column_name
from
(
    values{% for key, test in tests.items() -%}
        {%- if 'test_metadata' in test %}
        ('{{ test.name }}', '{{ test.alias }}', '{{ test.test_metadata.name }}', '{{ test.file_key_name }}', '{{ test.test_metadata.kwargs.column_name }}')
        {%- else %}
        ('{{ test.name }}', '{{ test.alias }}', null, null, null)
        {%- endif -%}
        {%- if not loop.last -%},{%- endif -%}
    {%- endfor %}
) as a(
    test_name,
    test_alias,
    test_type_name,
    model_name,
    column_name
)
{% endmacro %}

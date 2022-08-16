{% test equal_rowcount_where(model, compare_model) %}
  {{
      return(adapter.dispatch('equal_rowcount_where', 'branch_utils')(
      model,
      compare_model,
      source_where="",
      target_where=""
    ))
}}
{% endtest %}

{% macro default__test_equal_rowcount_where(
    model,
    compare_model,
    source_where="",
    target_where=""
) %}

{#-- Needs to be set at parse time, before we return '' below --#}
{{ config(fail_calc = 'coalesce(diff_count, 0)') }}

{#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
{%- if not execute -%}
    {{ return('') }}
{% endif %}

with a as (

    select count(*) as count_a from {{ model }}

),
b as (

    select count(*) as count_b from {{ compare_model }}

),
final as (

    select
        count_a,
        count_b,
        abs(count_a - count_b) as diff_count
    from a
    cross join b

)

select * from final

{% endmacro %}
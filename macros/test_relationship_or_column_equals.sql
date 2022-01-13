{%
    test relationship_or_column_equals(
        model,
        column_name,
        field,
        to,
        test_column="is_deleted",
        test_value="false"
    )
%}

with parent as (
    select
        {{ field }} as id
    from
        {{ to }}
), child as (
    select
        {{ column_name }} as id,
        {{ test_column }}
    from
        {{ model }}
)
select
    *
from
    child
where
    id is not null
    and id not in (select id from parent)
    and child.{{ test_column }} != {{ test_value }}

{% endtest %}

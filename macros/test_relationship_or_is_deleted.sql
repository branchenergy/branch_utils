{% test relationship_or_is_deleted(model, column_name, field, to) %}

with parent as (
    select
        {{ field }} as id
    from
        {{ to }}
), child as (
    select
        {{ column_name }} as id,
        is_deleted
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
    and child.is_deleted = false

{% endtest %}

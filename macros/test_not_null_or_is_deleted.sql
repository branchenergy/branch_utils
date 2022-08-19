{% test not_null_or_is_deleted(model, column_name) %}
select
    *
from
    {{ model }}
where
    {{ column_name }} is null
    and is_deleted = false

{% endtest %}

{%
    test not_null_or_column_equals(
        model,
        column_name,
        test_column="is_deleted",
        test_value="false"
    )
%}
select
    *
from
    {{ model }}
where
    {{ column_name }} is null
    and {{ test_column }} != {{ test_value }}

{% endtest %}

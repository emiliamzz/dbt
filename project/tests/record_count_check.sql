-- Define the expected record counts for each table
{% set expected_counts = {
  'CUSTOMERS': 50,
  'EMPLOYEES': 20,
  'STORES': 10,
  'SUPPLIERS': 5,
  'PRODUCTS': 100,
  'ORDERITEMS': 1000,
  'ORDERS': 200
} %}

-- Test the count of records in each table
{% for table, expected_count in expected_counts.items() %}
  SELECT '{{ table }}' AS table_name,
         (SELECT COUNT(*) FROM {{ source('landing', table) }}) AS record_count,
         {{ expected_count }} AS expected_count
  FROM {{ source('landing', table) }}
  WHERE (SELECT COUNT(*) FROM {{ source('landing', table) }}) < {{ expected_count }}
  {% if not loop.last %} UNION ALL {% endif %}
{% endfor %}
SELECT
  "employeeID",
  "territoryID"
FROM
  {{ source("fact", "fact_employee_territories") }}

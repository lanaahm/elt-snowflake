SELECT
  "orderID",
  "customerID",
  "employeeID",
  "orderDate",
  "requiredDate",
  "shippedDate",
  "shipVia",
  "freight",
  "shipName",
  "shipAddress",
  "shipCity",
  "shipRegion",
  "shipPostalCode",
  "shipCountry"
FROM
  {{ source("fact", "fact_orders") }}
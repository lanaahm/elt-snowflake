SELECT
  "orderID",
  "productID",
  "unitPrice",
  "quantity",
  "discount"
FROM
  {{ source("fact", "fact_order_details") }}

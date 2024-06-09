SELECT 
  "shipperID",
  "companyName",
  "phone"
FROM 
    {{ source("dim", "dim_shippers") }}
SELECT 
  "customerID",
  "companyName",
  "contactName",
  "contactTitle",
  "address",
  "city",
  "region",
  "postalCode",
  "country",
  "phone",
  "fax"
FROM 
    {{ source("dim", "dim_customers") }}
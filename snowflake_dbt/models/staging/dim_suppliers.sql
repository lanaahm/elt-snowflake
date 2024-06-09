SELECT 
  "supplierID",
  "companyName",
  "contactName",
  "contactTitle",
  "address",
  "city",
  "region",
  "postalCode",
  "country",
  "phone",
  "fax",
  "homePage"
FROM 
  {{ source("dim", "dim_suppliers") }}
SELECT 
  "productID",
  "productName",
  "supplierID",
  "categoryID",
  "quantityPerUnit",
  "unitPrice",
  "unitsInStock",
  "unitsOnOrder",
  "reorderLevel",
  "discontinued"
FROM 
    {{ source("dim", "dim_products") }}
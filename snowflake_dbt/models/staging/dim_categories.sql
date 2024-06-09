SELECT 
  "categoryID",
  "categoryName",
  "description",
  "picture"
FROM 
    {{ source("dim", "dim_categories") }}
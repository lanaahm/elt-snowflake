SELECT 
  "territoryID",
  "territoryDescription",
  "regionID"
FROM 
  {{ source("dim", "dim_territories") }}
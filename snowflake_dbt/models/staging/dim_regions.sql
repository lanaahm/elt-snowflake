SELECT 
  "regionID",
  "regionDescription"
FROM 
  {{ source("dim", "dim_regions") }}
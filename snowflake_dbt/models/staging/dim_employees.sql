SELECT 
  "employeeID",
  "lastName",
  "firstName",
  "title",
  "titleOfCourtesy",
  "birthDate",
  "hireDate",
  "address",
  "city",
  "region",
  "postalCode",
  "country",
  "homePhone",
  "extension",
  "photo",
  "notes",
  "reportsTo",
  "photoPath"
FROM 
    {{ source("dim", "dim_employees") }}
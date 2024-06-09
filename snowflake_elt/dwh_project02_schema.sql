CREATE TABLE IF NOT EXISTS dim_regions (
  "regionID" int PRIMARY KEY,
  "regionDescription" varchar
);

CREATE TABLE IF NOT EXISTS dim_territories (
  "territoryID" varchar PRIMARY KEY,
  "territoryDescription" varchar,
  "regionID" int,
  FOREIGN KEY ("regionID") REFERENCES dim_regions ("regionID")
);

CREATE TABLE IF NOT EXISTS dim_suppliers (
  "supplierID" int PRIMARY KEY,
  "companyName" varchar,
  "contactName" varchar,
  "contactTitle" varchar,
  "address" varchar,
  "city" varchar,
  "region" varchar,
  "postalCode" varchar,
  "country" varchar,
  "phone" varchar,
  "fax" varchar,
  "homePage" varchar
);

CREATE TABLE IF NOT EXISTS dim_shippers (
  "shipperID" int PRIMARY KEY,
  "companyName" varchar,
  "phone" varchar
);

CREATE TABLE IF NOT EXISTS dim_categories (
  "categoryID" int PRIMARY KEY,
  "categoryName" varchar,
  "description" text,
  "picture" varchar
);

CREATE TABLE IF NOT EXISTS dim_products (
  "productID" int PRIMARY KEY,
  "productName" varchar,
  "supplierID" int,
  "categoryID" int,
  "quantityPerUnit" varchar,
  "unitPrice" numeric,
  "unitsInStock" int,
  "unitsOnOrder" int,
  "reorderLevel" int,
  "discontinued" boolean,
  FOREIGN KEY ("supplierID") REFERENCES dim_suppliers ("supplierID"),
  FOREIGN KEY ("categoryID") REFERENCES dim_categories ("categoryID")
);

CREATE TABLE IF NOT EXISTS dim_customers (
  "customerID" varchar PRIMARY KEY,
  "companyName" varchar,
  "contactName" varchar,
  "contactTitle" varchar,
  "address" varchar,
  "city" varchar,
  "region" varchar,
  "postalCode" varchar,
  "country" varchar,
  "phone" varchar,
  "fax" varchar
);

CREATE TABLE IF NOT EXISTS dim_employees (
  "employeeID" int PRIMARY KEY,
  "lastName" varchar,
  "firstName" varchar,
  "title" varchar,
  "titleOfCourtesy" varchar,
  "birthDate" date,
  "hireDate" date,
  "address" varchar,
  "city" varchar,
  "region" varchar,
  "postalCode" varchar,
  "country" varchar,
  "homePhone" varchar,
  "extension" varchar,
  "photo" varchar,
  "notes" text,
  "reportsTo" int,
  "photoPath" varchar
);

CREATE TABLE IF NOT EXISTS fact_orders (
  "orderID" int PRIMARY KEY,
  "customerID" varchar,
  "employeeID" int,
  "orderDate" date,
  "requiredDate" date,
  "shippedDate" date,
  "shipVia" int,
  "freight" numeric,
  "shipName" varchar,
  "shipAddress" varchar,
  "shipCity" varchar,
  "shipRegion" varchar,
  "shipPostalCode" varchar,
  "shipCountry" varchar,
  FOREIGN KEY ("customerID") REFERENCES dim_customers ("customerID"),
  FOREIGN KEY ("employeeID") REFERENCES dim_employees ("employeeID"),
  FOREIGN KEY ("shipVia") REFERENCES dim_shippers ("shipperID")
);

CREATE TABLE IF NOT EXISTS fact_order_details (
  "orderID" int,
  "productID" int,
  "unitPrice" numeric,
  "quantity" int,
  "discount" numeric,
  FOREIGN KEY ("orderID") REFERENCES fact_orders ("orderID"),
  FOREIGN KEY ("productID") REFERENCES dim_products ("productID")
);

CREATE TABLE IF NOT EXISTS fact_employee_territories (
  "employeeID" int,
  "territoryID" varchar,
  FOREIGN KEY ("employeeID") REFERENCES dim_employees ("employeeID"),
  FOREIGN KEY ("territoryID") REFERENCES dim_territories ("territoryID")
);
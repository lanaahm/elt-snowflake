#! Data Source
source_data = {
  "regions": "https://raw.githubusercontent.com/graphql-compose/graphql-compose-examples/master/examples/northwind/data/csv/regions.csv",
  "territories": "https://raw.githubusercontent.com/graphql-compose/graphql-compose-examples/master/examples/northwind/data/csv/territories.csv",
  "suppliers": "https://raw.githubusercontent.com/graphql-compose/graphql-compose-examples/master/examples/northwind/data/csv/suppliers.csv",
  "shippers": "https://raw.githubusercontent.com/graphql-compose/graphql-compose-examples/master/examples/northwind/data/csv/shippers.csv",
  "categories": "https://raw.githubusercontent.com/graphql-compose/graphql-compose-examples/master/examples/northwind/data/csv/categories.csv",
  "products": "https://raw.githubusercontent.com/graphql-compose/graphql-compose-examples/master/examples/northwind/data/csv/products.csv",
  "customers": "https://raw.githubusercontent.com/graphql-compose/graphql-compose-examples/master/examples/northwind/data/csv/customers.csv",
  "employees": "https://raw.githubusercontent.com/graphql-compose/graphql-compose-examples/master/examples/northwind/data/csv/employees.csv",
  "orders": "https://raw.githubusercontent.com/graphql-compose/graphql-compose-examples/master/examples/northwind/data/csv/orders.csv",
  "order_details": "https://raw.githubusercontent.com/graphql-compose/graphql-compose-examples/master/examples/northwind/data/csv/order_details.csv",
  "employee_territories": "https://raw.githubusercontent.com/graphql-compose/graphql-compose-examples/master/examples/northwind/data/csv/employee_territories.csv"
}

warehouse_tables = {
  "regions": "dim_regions",
  "territories": "dim_territories",
  "suppliers": "dim_suppliers",
  "shippers": "dim_shippers",
  "categories": "dim_categories",
  "products": "dim_products",
  "customers": "dim_customers",
  "employees": "dim_employees",
  "orders": "fact_orders",
  "order_details": "fact_order_details",
  "employee_territories": "fact_employee_territories"
}

ddl_statements = {
  "dim_regions": """
    CREATE TABLE IF NOT EXISTS dim_regions (
    "regionID" int PRIMARY KEY,
    "regionDescription" varchar
    );
  """,
  "dim_territories": """
    CREATE TABLE IF NOT EXISTS dim_territories (
    "territoryID" varchar PRIMARY KEY,
    "territoryDescription" varchar,
    "regionID" int,
    FOREIGN KEY ("regionID") REFERENCES dim_regions ("regionID")
    );
  """,
  "dim_suppliers": """
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
  """,
  "dim_shippers": """
    CREATE TABLE IF NOT EXISTS dim_shippers (
    "shipperID" int PRIMARY KEY,
    "companyName" varchar,
    "phone" varchar
    );
  """,
  "dim_categories": """
    CREATE TABLE IF NOT EXISTS dim_categories (
    "categoryID" int PRIMARY KEY,
    "categoryName" varchar,
    "description" text,
    "picture" varchar
    );
  """,
  "dim_products": """
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
  """,
  "dim_customers": """
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
  """,
  "dim_employees": """
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
  """,
  "fact_orders": """
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
  """,
  "fact_order_details": """
    CREATE TABLE IF NOT EXISTS fact_order_details (
    "orderID" int,
    "productID" int,
    "unitPrice" numeric,
    "quantity" int,
    "discount" numeric,
    FOREIGN KEY ("orderID") REFERENCES fact_orders ("orderID"),
    FOREIGN KEY ("productID") REFERENCES dim_products ("productID")
    );
  """,
  "fact_employee_territories": """
    CREATE TABLE IF NOT EXISTS fact_employee_territories (
    "employeeID" int,
    "territoryID" varchar,
    FOREIGN KEY ("employeeID") REFERENCES dim_employees ("employeeID"),
    FOREIGN KEY ("territoryID") REFERENCES dim_territories ("territoryID")
    );
  """
}
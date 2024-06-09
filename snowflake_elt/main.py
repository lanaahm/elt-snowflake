import os
import pandas as pd
from snowflake.snowpark import Session
from dotenv import load_dotenv, find_dotenv

from config import ddl_statements, source_data, warehouse_tables

def create_tables(session):
  """Create tables in the data warehouse if they do not exist."""
  try:
    # Specify the database and schema
    session.sql("USE WAREHOUSE COMPUTE_WH").collect()
    session.sql("USE DATABASE DWH_PROJECT02").collect()
    session.sql("USE SCHEMA PUBLIC").collect()

    for table, ddl in ddl_statements.items():
      session.sql(ddl).collect()
      print(f"Table {table} created successfully")
  except Exception as e:
    print(f"Error creating tables: {e}")

def extract_data(table_name):
  """Extract data from a table in the OLTP database."""
  if table_name == "territories":
    df = pd.read_csv(f"{source_data[table_name]}", dtype={"territoryID": "str"})
  else:
    df = pd.read_csv(f"{source_data[table_name]}")
  print(f"Extract Data {source_data[table_name]} Success")
  return df

def get_unique_key(table_name):
  """Retrieve the unique key of the table."""
  unique_keys = {
    "dim_regions": "regionID",
    "dim_territories": "territoryID",
    "dim_suppliers": "supplierID",
    "dim_shippers": "shipperID",
    "dim_categories": "categoryID",
    "dim_products": "productID",
    "dim_customers": "customerID",
    "dim_employees": "employeeID",
    "fact_orders": "orderID",
    "fact_order_details": ["orderID", "productID", "unitPrice", "quantity", "discount"],
    "fact_employee_territories": ["employeeID", "territoryID"]
  }
  if table_name in unique_keys:
    return unique_keys[table_name]
  else:
    raise ValueError("Table name not recognized.")

def remove_duplicate_data(new_data, existing_data, unique_key):
  """Remove duplicates from new data based on existing data."""
  if isinstance(unique_key, list):
    unique_values = set(map(tuple, existing_data[unique_key].values))
    return new_data[~new_data.apply(lambda row: tuple(row[unique_key]) in unique_values, axis=1)]
  else:
    unique_values = set(existing_data[unique_key])
    return new_data[~new_data[unique_key].isin(unique_values)]
    
def load_data(session, df, table_name):
  """Load the transformed data into the target table in the data warehouse."""
  try:
    df_load = session.table(table_name).to_pandas()
    unique_key = get_unique_key(table_name)

    df = remove_duplicate_data(df, df_load, unique_key)
    
    df = session.create_dataframe(df)
    df.write.mode("append").save_as_table(table_name)
    print(f"Load Data {table_name} Success")
  except Exception as e:
    print(f"Error loading data into {table_name}: {e}")

def main():
  # Load environment variables from .env file
  env_file = find_dotenv(".env.dev")
  load_dotenv(env_file)

  # Retrieve environment variables
  connection_parameters = {
    "account": os.getenv("SNOWFLAKE_ACCOUNT"),
    "user": os.getenv("SNOWFLAKE_USER"),
    "password": os.getenv("SNOWFLAKE_PASSWORD"),
    "warehouse": os.getenv("SNOWFLAKE_ROLE"),
    "role": os.getenv("SNOWFLAKE_WAREHOUSE"),
    "database": os.getenv("SNOWFLAKE_DATABASE"),
    "schema": os.getenv("SNOWFLAKE_SCHEMA")
  }
  
  try:
    # Create a Snowflake session
    session = Session.builder.configs(connection_parameters).create()
    create_tables(session)
  
    for source_name, target_name in warehouse_tables.items():
      source_data = extract_data(source_name)
      load_data(session, source_data, target_name)
  finally:
    session.close()

if __name__ == "__main__":
  main()
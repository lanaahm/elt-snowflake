-- Menyusun faktur order dan detailnya untuk menghitung gross revenue
with order_details as (
  select
    o."orderID",
    o."orderDate",
    od."productID",
    od."unitPrice",
    od."quantity",
    od."discount"
  from
    {{ ref("fact_orders") }} o
  join
    {{ ref("fact_order_details") }} od
  on
    o."orderID" = od."orderID"
),

-- Menghitung gross revenue tiap produk
product_revenue as (
  select
    od."orderDate",
    p."supplierID",
    od."productID",
    od."unitPrice",
    od."quantity",
    od."discount",
    -- Menghitung gross revenue per produk
    (od."unitPrice" - (od."unitPrice" * od."discount")) * od."quantity" as "gross_revenue"
  from
    order_details od
  join
    {{ ref("dim_products") }} p
  on
    od."productID" = p."productID"
),

-- Mengelompokkan gross revenue per supplier tiap bulan
supplier_monthly_revenue as (
  select
    date_trunc("month", pr."orderDate") as "month",
    pr."supplierID",
    -- Menghitung total gross revenue per supplier tiap bulan
    sum(pr."gross_revenue") as "total_gross_revenue"
  from
    product_revenue pr
  group by
    date_trunc("month", pr."orderDate"),
    pr."supplierID"
)

-- Menggabungkan dengan dimensi supplier untuk mendapatkan informasi nama supplier
select
  smr."month",
  s."supplierID",
  s."companyName" as "supplierName",
  smr."total_gross_revenue"
from
  supplier_monthly_revenue smr
join
  {{ ref("dim_suppliers") }} s
on
  smr."supplierID" = s."supplierID"

-- Menghitung gross revenue untuk setiap produk pada setiap pesanan
with product_revenue as (
  select
    o."orderDate",
    p."categoryID",
    od."productID",
    od."unitPrice",
    od."quantity",
    od."discount",
    -- Menghitung gross revenue per produk
    (od."unitPrice" - (od."unitPrice" * od."discount")) * od."quantity" as "gross_revenue"
  from
    {{ ref("fact_orders") }} o
  join
    {{ ref("fact_order_details") }} od
  on
    o."orderID" = od."orderID"
  join
    {{ ref("dim_products") }} p
  on
    od."productID" = p."productID"
),

-- Menghitung total gross revenue per kategori produk tiap bulan
category_monthly_revenue as (
  select
    date_trunc("month", pr."orderDate") as "month",
    pr."categoryID",
    -- Menghitung total gross revenue per kategori produk tiap bulan
    sum(pr."gross_revenue") as "total_gross_revenue"
  from
    product_revenue pr
  group by
    date_trunc("month", pr."orderDate"),
    pr."categoryID"
),

-- Menetapkan peringkat kategori produk berdasarkan total gross revenue tiap bulan
ranked_categories as (
  select
    cmr."month",
    cmr."categoryID",
    c."categoryName",
    cmr."total_gross_revenue",
    -- Memberikan peringkat pada setiap kategori produk berdasarkan total gross revenue
    rank() over (partition by cmr."month" order by cmr."total_gross_revenue" desc) as "category_rank"
  from
    category_monthly_revenue cmr
  join
    {{ ref("dim_categories") }} c
  on
    cmr."categoryID" = c."categoryID"
)

-- Memilih kategori produk paling banyak terjual tiap bulan
select
  rc."month",
  rc."categoryID",
  rc."categoryName",
  rc."total_gross_revenue"
from
  ranked_categories rc
where
  rc."category_rank" = 1

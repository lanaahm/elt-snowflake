-- Menghitung gross revenue untuk setiap pesanan yang diproses oleh setiap karyawan pada setiap bulan
with employee_revenue as (
  select
    date_trunc("month", o."orderDate") as "month",
    o."employeeID",
    -- Menghitung total gross revenue per pesanan
    sum((od."unitPrice" - (od."unitPrice" * od."discount")) * od."quantity") as "total_gross_revenue"
  from
    {{ ref("fact_orders") }} o
  join
    {{ ref("fact_order_details") }} od
  on
    o."orderID" = od."orderID"
  group by
    date_trunc("month", o."orderDate"),
    o."employeeID"
),

-- Memberikan peringkat pada setiap karyawan berdasarkan total gross revenue tiap bulan
ranked_employees as (
  select
    "month",
    "employeeID",
    "total_gross_revenue",
    -- Memberikan peringkat pada setiap karyawan berdasarkan total gross revenue
    rank() over (partition by "month" order by "total_gross_revenue" desc) as "employee_rank"
  from
    employee_revenue
)

-- Memilih karyawan terbaik berdasarkan total gross revenue yang dihasilkan dalam satu bulan
select
  re."month",
  re."employeeID",
  e."lastName" || ', ' || e."firstName" as "employeeName",
  re."total_gross_revenue"
from
  ranked_employees re
join
  {{ ref("dim_employees") }} e
on
  re."employeeID" = e."employeeID"
where
  re."employee_rank" = 1

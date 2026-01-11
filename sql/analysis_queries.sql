use ecom_an;

-- 1 What is the TOTAL REVENUE?

select sum(oi.quantity*p.price) as total_revenue from order_items oi 
join products p on oi.product_id= p.product_id;

-- 2 What is the MONTHLY REVENUE TREND?

select o.order_month, sum(oi.quantity*p.price)as monthly_revenue from orders o
join order_items oi on o.order_id=oi.order_id
join products p on oi.product_id=p.product_id
group by o.order_month order by o.order_month;

-- 3 What is the AVERAGE ORDER VALUE(AOV)?

select avg(order_total) as avg_order_value
from (select o.order_id,sum(oi.quantity*p.price) as order_total
from orders o
join order_items oi on o.order_id=oi.order_id
join  products p on oi.product_id=p.product_id
group by o.order_id) t;

-- 4 Top 10 PRODUCTS by REVENUE

select p.product_name,sum(oi.quantity*p.price) as product_revenue
from order_items oi 
join products p on oi.product_id=p.product_id
group by p.product_name
order by product_revenue desc limit 10;

-- 5 Revenue by CATEGORY

select c.category_name, sum(oi.quantity*p.price) as category_revenue
from order_items oi
join products p on oi.product_id=p.product_id
join categories c on p.category_id=c.category_id
group by c.category_name
order by category_revenue desc;

-- 6 Top Customers by Revenue

select c.customer_id,round(sum(oi.quantity*p.price),2) as total_spend
from customers c
join orders o on c.customer_id=o.customer_id
join order_items oi on o.order_id=oi.order_id
join products p on oi.product_id=p.product_id
group by c.customer_id order by total_spend desc 
limit 10;

-- 7 City-wise Revenue Performance (Top 10)

select c.city,round(sum(oi.quantity*p.price),2) as city_revenue
from customers c
join orders o on c.customer_id=o.customer_id
join order_items oi on o.order_id=oi.order_id
join products p on oi.product_id=p.product_id
group by c.city order by city_revenue desc limit 10;

-- 8 Repeat vs One-Time Customers

select case when max_order_seq=1 then 'One-Time-Customer' 
else 'Repeat Customer' end as customer_type, count(*) as customer_count
from(select customer_id, max(order_seq) as max_order_seq 
from(select customer_id,row_number() over(partition by customer_id order by order_date) as order_seq
from orders) x group by customer_id)y group by customer_type;
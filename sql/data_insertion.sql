use ecom_an;

insert into customers(customer_id,gender,age,city)
select distinct customer_id,gender,age,city from online_retail_cleaned;

insert into categories(category_id,category_name) 
select distinct category_id,category_name from online_retail_cleaned;

insert into products (product_id, product_name, category_id, price)
select  product_id, any_value(product_name) as product_name, any_value(category_id) as category_id, max(price) as price from online_retail_cleaned
group by product_id;

insert into orders(customer_id, order_date, order_month, payment_method)
select distinct customer_id, order_date, order_month, payment_method from online_retail_cleaned;

insert into order_items(order_id, product_id, quantity)
select o.order_id,c.product_id,c.quantity from online_retail_cleaned c
join orders o on c.customer_id=o.customer_id 
and c.order_date=o.order_date
and c.payment_method=o.payment_method;

insert into reviews(order_id,review_score)
select o.order_id,c.review_score from online_retail_cleaned c
join orders o on c.customer_id=o.customer_id
and c.order_date=o.order_date
and c.payment_method=o.payment_method where c.review_score is not null;

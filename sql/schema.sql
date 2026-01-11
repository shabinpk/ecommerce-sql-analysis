create database ecom_an;
use ecom_an;
set sql_safe_updates=0;
show tables;
select  * from online_retail_cleaned limit 10;
desc online_retail_cleaned;
alter table online_retail_cleaned
modify order_date DATE;
update online_retail_cleaned
set review_score=Null
where review_score='';
alter table online_retail_cleaned
modify review_score int;
alter table online_retail_cleaned
add order_month_derived varchar(7);
update online_retail_cleaned
set order_month_derived= date_format(order_date,'%Y-%m');

-- creating relational tables

create table customers( customer_id int primary key, gender varchar(50),age int,city varchar(100));

create table categories(category_id int primary key, category_name varchar(100));

create table products(product_id int primary key, product_name varchar(255), category_id int, price double,
foreign key( category_id) references categories(category_id));

create table orders(order_id int auto_increment primary key, customer_id int, order_date date, order_month varchar(7),
payment_method varchar(50), foreign key( customer_id) references customers(customer_id));

create table order_items( order_id int, product_id int, quantity int, primary key(order_id,product_id),
foreign key(order_id) references orders(order_id), foreign key(product_id) references products(product_id));

create table reviews(order_id int primary key, review_score int, foreign key(order_id) references orders(order_id));

-- selecting table after importing from wizard;
select*from book1;

-- record counting to ensure data matches ;
select count(*) from book1;

-- to check table data types ;
describe book1;

-- check for duplicate records ;
select order_id ,count(*)
from book1
group by order_id
having count(*) >1;


-- change datatype ;
alter table book1 
modify column date date,
modify column order_id varchar(250),
modify column customer_id varchar(250);

-- renaming column name ;
alter table book1 
rename column Total_Sales to total_sale;

-- null checks ;
select* from book1 where total_sales is null ;

-- total sales ;
select 
sum(total_sale) as total_revenue,
count(*) as total_orders,
avg(total_sale) as avg_order_value
from book1;

-- seasonal trends (when the sale was high?);
SELECT 
monthname(date) as month_name,
sum(total_sale) as monthly_revenue,
count(*) as total_order
from book1
group by month_name , month(date)
order by monthly_revenue desc;
  
-- creating a view for monthly revenue(seasonal trend) ;
create view monthly_revenue as
SELECT 
monthname(date) as month_name,
round(sum(total_sale),2) as monthly_revenue,
count(*) as total_order
from book1
group by month_name , month(date)
order by month (date) ;
select* from monthly_revenue;

-- top products view 
CREATE VIEW top_products_performance AS

SELECT 
    product_name,  
   round(SUM(total_sale),2) AS Revenue,
    COUNT(*) AS Units_Sold 
FROM book1 
GROUP BY product_name 
 ORDER BY Revenue DESC limit 10;
 select*from top_products_performance;

-- top category view 
create view top_category as
select product_category,
 round(sum(total_sale),2) as revenue,
 count(*) as unit_sold
 from book1
 group by Product_Category
 order by revenue desc limit 10 ;
select*from top_category;

-- create view for day wise sales ;
CREATE view daily_patterns AS
SELECT 
    DAYNAME(date) AS day_of_week, 
    round(SUM(total_sale),2)  AS total_revenue,
    COUNT(*) AS total_orders
FROM book1
GROUP BY day_of_week, DAYOFWEEK(date)
ORDER BY DAYOFWEEK(date);

select * from daily_patterns; 

-- customer analysis rank wise view ( rfm ) To know customer loyality;
create view customer_analysis
as 
select (customer_id) as customer_no , 
round(sum(total_sale),2) as money_spent,
count(*)  as sale_count ,
case 
when count(*)> 5 then "loyal" 
when count(*)=5 then "standard "
else "occasional"  
end as customer_seg
from book1 
group by customer_id 
order by money_spent desc;

select* from customer_analysis ;

-- view for product performance as per reviews ;
create view critical_customer_rating 
as 
select
order_id,product_name,review_rating,review_text,state
from book1
where Review_Rating <=2 
order by review_rating asc;

select*from critical_customer_rating ;



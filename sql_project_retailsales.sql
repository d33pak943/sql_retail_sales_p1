create database sql_project_1;
create table retail_sales(transactions_id int primary key,	
sale_date date,	
sale_time time,	
customer_id int,
gender varchar(15),
age int,
category varchar(25),	
quantiy int,
price_per_unit float,
cogs float,
total_sale float);
select*from retail_sales ;
-- Data Exploration

-- How many sales we have?
select count(*) as Total_sales from retail_sales;
-- how many unique customers we have?
select count(distinct customer_id) as total_customers from retail_sales;
-- how many categories?
select count(distinct category) as total_categories from retail_sales;
-- category names
select distinct category as category_name from retail_sales;

-- Data Cleaning

select*from retail_sales
where sale_time is null;
select*from retail_sales
where transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null;
DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;



-- Data Analysis & Business key problems

-- 1. Write a sql query to retrive all columns for sales made on '2022-11-05'

select* from retail_sales 
where sale_date="2022-11-05";

-- 2.Write a sql query to retrive all transcations where the category is 'clothing' and the quantity sold is more than 4 in the month of nov-2022

select*from retail_sales
where category="clothing" and
quantiy >=4
and sale_date like '2022-11%';

-- 3.Write a sql query to calculate the total sales for each category

select category, sum(total_sale) as total_sales,count(*) as total_orders from retail_sales
group by 1;

-- 4.Write a sql query to find the average age of customers who purchased items from  the 'Beauty' category

select category,round(avg(age),2) as avg_age from retail_sales
where category='Beauty';

-- 5.Write a sql query to find all transcations where the total sale is greater than 1000

select * from retail_sales
where total_sale>1000;

-- 6. write a sql query to find total number of transcations (transcation_id) made by each gender in each category

select category, gender,count(*) as total_trans from retail_sales
group by category,gender
order by 1;

-- 7. Write a sql query to calculate the average sale for each month. find out best selling month in each year

select * from (
select year(sale_date), month(sale_date),round(avg(total_sale),2) as avg_sale,
rank() over(partition by year(sale_date) order by avg(total_sale) desc) as rankk
from retail_sales 
group by 1,2 ) as t1
where rankk=1;

-- 8.Write a sql query to find top 5 customers based on highest total sales

select customer_id,sum(total_sale) as total_sales from retail_sales
group by 1 
order by 2 desc 
limit 5;

-- 9.Write a sql query to find the number of unique customers who purchased items from each category

select category,count(distinct customer_id) as cnt_unique_cs from retail_sales
group by 1; 

-- 10.Write a sql query to create each shift and number of orders(Example Morning<12,Afternoon Between 12&17,Evening>17)

select shift,count(*) as number_of_orders from(
 select *,
     case
        when hour(sale_time)<12 then 'Morning'
		when hour(sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail_sales) as t2
group by shift;
 
 with shift_sales as(
select *,
   case
      when hour(sale_time)<12 then 'Morning'
      when hour(sale_time) between 12 and 17 then 'Afternoon'
      else 'Evening'
	end as shift
from retail_sales)
select shift,count(*) from shift_sales
group by shift;
     

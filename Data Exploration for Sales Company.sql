# Data Exploration FOR A SALES COMPANY using MYSQL #

SELECT * FROM company.calendar;
select * from company.data;
select * FROM company.customers;
select * FROM company.product;
select * FROM company.location;

# 1.	A query that returns the total revenue and total profit.
select sum(sales) as Revenue from company.data
ORDER BY sales desc limit 5;
select sum(profit) FROM company.data;

# 2. A query that returns the DISTINCT values of the product sub-category
select * FROM company.product;
select distinct(sub_category) FROM company.product;

# 3.	A Query to Retrieve the SUM of revenue by product sub-category
select a.sub_category, sum(b.sales) as revenue
FROM product as a
INNER JOIN
data as b
on
a.product_id = b.product_id
GROUP BY sub_category 
order by revenue DESC LIMIT 3;

# 4.	A Query to Retrieve the top 10 customers by revenue
SELECT distinct(customer_id), sum(sales) AS  revenue  FROM company.data 
group by customer_id 
order by revenue desc LIMIT 10;

#5.	A Query to Return the profit by country and order by the profit in Descending order.
SELECT * FROM company.location;
SELECT a.country, sum(b.profit) as profits 
FROM company.location as a
INNER JOIN company.data as b 
ON 
a.state_id = b.state_id
GROUP BY country
ORDER BY profit DESC;

#6.	A Query to return month with the highest revenue made in 2015.
select * from company.data;
select * from company.calendar;

SELECT a.month_name, sum(b.sales) AS revenue, a.year 
FROM company.calendar AS a 
INNER JOIN company.data AS b 
ON 
a.date = b.date 
WHERE year = 2015
 GROUP BY month_name
ORDER BY revenue desc LIMIT 1;

# 7.	A query that returns the total cost for each year.
SELECT * FROM company.data;
SELECT a.year,sum(b.profit) AS Total_profit,sum(b.unit_cost*b.order_quantity) AS Total_cost FROM company.calendar AS a 
INNER JOIN company.data AS b
ON 
a.date = b.date
group by year
ORDER BY year;

# 8.	A query that returns the total revenue and total profit for Canada and France

SELECT a.country,sum(b.sales) As Total_revenue,sum(b.profit) As total_profit
 FROM 
 company.location AS a
INNER JOIN 
company.data as b
on
a.state_id = b.state_id
group by country
having  country = "canada" 
or country = "france";
 
# 9.A query that returns the total profit of products that starts with letter “H”

select a.product, sum(b.profit) As Total_profit 
from 
	company.product As a
INNER JOIN
	company.data As b
ON
	a.product_id = b.product_id
GROUP BY product
having product like "H%";

# 10.	A query that returns the total revenue by month, ranked by revenue in ascending order.

select a.month_name, sum(b.sales) as revenue
 from company.calendar as a
 inner join 
company.data as b 
on 
a.date = b.date
group by month_name
order by revenue;

# 11.	A query to Retrieve Top 10 states by average revenue

select a.state, avg(b.sales) as average_revenue 
from company.location as a
inner join 
company.data as b 
on 
a.state_id = b.state_id
group by state
order by average_revenue desc 
limit 10;

# 12.	A Query to Retrieve countries by order quantity

select a.country,sum(b.order_quantity) as Total_quantity 
from company.location as a
inner join 
company.data as b
on 
a.state_id = b.state_id
group by country
order by Total_quantity desc;

# 13.	A query to show the profit margin for the year 2016

select(SUM(a.sales) - SUM(a.unit_cost * a.order_quantity) / SUM(a.sales))*100 as profit_margin, b.year 
from company.data as a 
inner join 
company.calendar as b
on 
a.date = b.date
group by year
having year = 2016;

# 14.	A query to show the most profitable product in United State in 2016 purchased by Males
select sum(a.profit) as total_profit,b.product,c.country,d.year,e.customer_gender
 from company.data as a 
inner join
company.product as b 
on 
a.product_id = b.product_id
inner join
company.location as c
on 
a.state_id = c.state_id
inner join
company.calendar as d
on
a.date = d.date
inner join
company.customers as e
on 
 a.customer_id = e.customer_id 
 WHERE c.country = 'United States' AND d.year = 2016 AND e.customer_gender = 'M'
group by product
order by total_profit desc limit 1;

# 15.A query to show the top 10 customers from British Columbia under the “Accessories Product Category”.
select * from company.data;
select * from company.location;
select * from company.product;
select * from company.customers;
#
select sum(a.sales) as total_sales,b.customer_id,c.state,d.product_category
from company.data as a
inner join
company.customers as b
on 
a.customer_id = b.customer_id
inner join
company.location as c
on 
a.state_id = c.state_id
inner join 
company.product as d
on 
a.product_id = d.product_id
where c.state = "British Columbia" and d.product_category = "Accessories"
group by customer_id
order by total_sales desc limit 10;

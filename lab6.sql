-- 1. Display the name and city of customers who live in any city that makes the most different kinds of products. 
-- (There are two cities that make the most different products. Return the name and city of customers from either one of those.) 
select distinct customers.city, customers.name
 from customers
 Where customers.city in (
                        Select Products.city
                         From Products
                           group by Products.city
                           order by count(Products.city) desc
     					    Limit 2
                         );

-- 2. Display the names of products whose priceUSD is strictly above the average priceUSD, in reverse-alphabetical order.
select products.name
 From products
  Where products.priceUSD > ( select avg(priceUSD) from products)
  order by products.name desc;


-- 3. Display the customer name, pid ordered, and the total for all orders, sorted by total from low to high. 
select Customers.name, Orders.pid, Orders.totalUSD
 From Customers
  Inner Join Orders
  On Customers.cid = Orders.cid
  Order by totalUSD Asc;
    
-- 4. Display all customer names (in alphabetical order) and their total ordered, and nothing more. Use coalesce to avoid showing NULLs.
Select Customers.name, sum(Coalesce(Orders.totalUSD,0))
 From Customers 
  Left Outer Join Orders 
   On Customers.cid = orders.cid
  Group By customers.name
  order by Customers.name asc;


-- 5. Display the names of all customers who bought products from agents based in Newark along with the names of the 
-- products they ordered, and the names of the agents who sold it to them.
select customers.name, Products.name, Agents.name
 From customers
  Inner Join Orders
   On customers.cid = Orders.cid
  Inner Join Products
   On Products.pid = Orders.pid
  Inner Join Agents
   On Agents.aid = Orders.aid
   where agents.city = 'Newark';


-- 6. Write a query to check the accuracy of the totalUSD column in the Orders table. This  means calculating Orders.totalUSD from data in other 
-- tables and comparing those values to the values in Orders. totalUSD. Display all rows in Orders where Orders.totalUSD is incorrect, if any.
Select orders.*, (products.priceUSD * Orders.qty) - (products.priceUSD * orders.qty * customers.discount * 0.01) as newtotal
 from orders 
  Inner Join Customers 
   on Orders.cid = Customers.cid
  Inner join Products 
   on orders.pid = products.pid
    where (products.priceUSD * Orders.qty) - (products.priceUSD * orders.qty * customers.discount * 0.01) <> orders.totalUSD;
	-- I wish I could just do where newtotal <> orders.totalUSD;

-- 7. What’s the difference between a LEFT OUTER JOIN and a RIGHT OUTER JOIN? Give example 
-- queries in SQL to demonstrate. (Feel free to use the CAP database to make your points here.)
-- A Left Outer Join takes Everything in the First, Left Table, and matches it with matching data from the right hand, second table, 
-- including null data from the left, when there is no match.
-- A right Outer Join does the same thing in reverse; Everything from the Second, Right Hand table, paired with matching data in the Left, 
-- First table, including null data from the right, when there is no match

-- Example of a Right Outer Join
Select Agents.name, customers.name
 from agents
  Right Outer Join Customers
   on agents.city = customers.city;

-- Example of a Left Outer Join
Select Agents.name, customers.name
 from agents
  Left Outer Join Customers
   on agents.city = customers.city;
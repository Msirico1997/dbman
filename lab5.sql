-- 1. Show the cities of agents booking an order for a customer whose id is 'c006'.
select agents.city
 From Agents
  Inner Join Orders
   On Orders.cid = 'c006'
  Where Orders.aid = Agents.aid
 

-- 2. Show the ids of products ordered through any agent who makes at least one order for a customer in Kyoto, 
-- sorted by pid from highest to lowest. Use joins; no subqueries. 
select Orders.pid
 From Orders 
  Inner Join Agents
   on orders.aid = agents.aid
  Inner Join customers
   on orders.cid = customers.cid
  Where customers.city = 'Kyoto'
order by orders.pid desc;


-- 3. Show the names of customers who have never placed an order. Use a subquery. 
Select name
 From customers
Where customers.cid Not in (
    						Select cid 
    						from orders
							);

-- 4. Show the names of customers who have never placed an order. Use an outer join. 
Select customers.name
 From orders Right Outer Join customers
  on orders.cid = customers.cid
 where orders.ordnumber is null;

-- 5. Show the names of customers who placed at least one order through an agent in their own city, along with those agent(s') names. 
Select distinct customers.name, agents.name
 From customers
  Inner Join agents
   on customers.city = agents.city
  Left Outer Join Orders
   on orders.cid = customers.cid
  where orders.aid = agents.aid;
  

-- 6. Show the names of customers and agents living in the same city, along with the name of the shared city, 
-- regardless of whether or not the customer has ever placed an order with that agent. 
select customers.name, agents.name, customers.city
 from customers
  Inner Join Agents
   on customers.city = Agents.city

-- 7. Show the name and city of customers who live in the city that makes the fewest different kinds of products. 
-- (Hint: Use count and group by on the Products table.)
select distinct customers.city, customers.name
 from customers
  inner Join Products
   on customers.city = Products.city
 Where Products.city = (
                        Select *
                         From (
                         select products.city
                          from products
                           group by Products.city
                           order by count(Products.city) asc
                             ) As L_H
                             Limit 1
                             )
-- THIS ONE WAS REALLY HARD
     
 
 
 
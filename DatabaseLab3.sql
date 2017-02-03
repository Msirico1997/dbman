-- 1. List the order number and total dollars of all orders. 
Select ordNumber, totalUSD
	from Orders;    
-- 2. List the name and city of agents named Smith. 
Select name, city
	from Agents 
	where name = 'Smith';
-- 3. List the id, name, and price of products with quantity more than 200,100.
Select pid, name, priceUSD
	from Products
    where quantity > 200100
-- 4. List the names and cities of customers in Duluth. 
Select name, city
	from Customers
    where city = 'Duluth';
-- 5. List the names of agents not in New York and not in Duluth.
Select name
	from Agents
    where city <> 'New York' AND city <> 'Duluth';
-- 6. List all data for products in neither Dallas nor Duluth that cost US $1 or more.
Select *
	from Products
    where city <> 'Dallas' AND city <> 'Duluth' AND priceUSD >= 1.00;
-- 7. List all data for orders in February or May.
Select *
	from Orders
    where month = 'Feb' OR month = 'May';
-- 8. List all data for orders in February of US $600 or more.
Select *
	from Orders
    where month = 'Feb' AND totalUSD >= 600;
-- 9. List all orders from the customer whose cid is C005.
Select *
	from Orders
    where cid = 'c005';
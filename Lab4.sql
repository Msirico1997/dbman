-- 1.Get the cities of agents booking an order for a customer whose cid is 'c006'. 
Select city 
From Agents 
Where Exists (Select *
              From orders
              Where cid = 'c006'
              );
              
-- 2.Get the distinct ids of products ordered through any agent who takes at least one 
-- order from a customer in Kyoto, sorted by pid from highest to lowest. (This is not the 
-- same as asking for ids of products ordered by customers in Kyoto.)
Select distinct *
from Products
Where Exists (Select aid
              From Orders
              Where Exists (Select *
                            From Customers
                            Where city = 'Kyoto'
                            )
              )
Order By pid DESC;

-- 3. Get the ids and names of customers who did not place an order through agent a01.
Select name, cid
From Customers
Where Exists (Select *
              From Orders
              Where aid <> 'a01'
              );
              
-- 4. Get the ids of customers who ordered both product p01 and p07. 
Select cid
From Orders
Where pid = (Select pid
             From Products
             Where Name = 'comb' OR Name = 'case'
             ); -- Couldn't Figure this one out
             
-- 5. Get the ids of products not ordered by any customers who placed any order through agent a08 in pid order from highest to lowest. 
select pid
From Products
Where NOT Exists ( Select cid
              From Orders
              Where Exists ( Select aid
                            From Orders
                            Where aid = ( Select aid
                                          From Agents
                                          Where name = 'Bond'
                                          )
                            )
              )
Order By pid Desc;     

-- 6. Get the name, discount, and city for all customers who place orders through agents in Tokyo or New York.
select name, discount, city
From Customers
Where Exists ( Select *
              From Orders
              Where Exists (Select aid
 			   				From Agents
   				 			Where city = 'New York' OR city = 'Tokyo'
 			   				)
              );
              
-- 7. Get all customers who have the same discount as that of any customers in Duluth or London
select *
From Customers
Where discount = (Select discount
                  From Customers
                  Where city = 'Duluth' or city = 'London'
                  ); -- Unsure of how to handle
                  
-- 8. Tell me about check constraints: What are they? What are they good for? What’s the 
-- advantage of putting that sort of thing inside the database? Make up some examples 
-- of good uses of check constraints and some examples of bad uses of check constraints. 
-- Explain the differences in your examples and argue your case

-- Check Constraints are good for ensuring that data value is within a certain range; The data is checked and either True or False is Returned
-- If you want to guarantee that the data is less than, greater than a certain value, this can be done with Check Constraints
-- The advantage of putting it in a database is to make sure that the Data stored is consistant and conforms to a certain standard
--
-- A good example would be
-- Create Table ClassicMovies (
-- 		name text,
-- 		year int,
-- 		CHECK (year < 1990));
-- This Constraint will ensure any film in this "ClassicMovies" table is from before 1990
-- 
-- A bad example would be
-- Create Table ClassicMovies (
-- 		name text,
-- 		productionyear int,
-- 		publishyear int
-- 		CHECK (publishyear > productionyear));
-- This Constraint is bad, because it eliminates the possibility of inserting a movie published in the same year it was produced.
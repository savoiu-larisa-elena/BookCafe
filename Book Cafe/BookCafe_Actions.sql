
-- update for customers table with AND, OR, NOT conditions and comparison operators
update customers
set customer_name = 'John A. Doe'
where customer_name = 'John Doe' AND customer_id >= 1;

-- update for employees table with BETWEEN and LIKE operators
update employees
set salary = salary * 1.1
where employee_name LIKE '%Alice%' AND salary BETWEEN 2000 AND 3000;

-- update for books table using IS NOT NULL
update books
set price = price * 0.9
where number_of_copies > 50 AND price IS NOT NULL;

-- delete from orders with NOT IN and comparison operators
delete from orders
where order_id NOT IN (select order_id from order_details) AND order_date < '2024-01-01';

-- delete from customers with IS NULL and OR conditions
delete from customers
where customer_name IS NULL OR customer_name = 'Jane Doe';


-- a. union and union all

-- find books that are either in the "Fantasy" genre or priced above $20, combining both conditions into a single list without duplicates
select title from books where genre_id = (select genre_id from genres where genre_name = 'Fantasy')
union
select title from books where price > 20;

-- get a list of customer names who either have placed an order handled by "Alice Johnson" or whose name starts with 'S'
select c.customer_name 
from customers c 
join orders o on c.customer_id = o.customer_id 
join employees e on o.employee_id = e.employee_id
where e.employee_name = 'Alice Johnson'
union all
select customer_name from customers where customer_name LIKE 'S%';

-- b. intersect and in

-- identify customers that attended an event and also placed an order
select c.customer_name
from customers c
where c.customer_id in (
    select customer_id 
    from event_registrations
    intersect
    select customer_id 
    from orders
);	

-- identify customers that ordered books and something from cafeteria
select c.customer_name
from customers c
where c.customer_id in (
	select customer_id
	from orders
	intersect
	select customer_id
	from cafe_orders
);

-- c. except and not in

-- empoyees that didnt handle any orders
select employee_id 
from employees 
except 
select employee_id 
from orders;

-- 
-- update a customer's name
update customers
set customer_name = 'Mary Doe'
where customer_name = 'John Doe' AND customer_id = 11;

-- give an employee a raise
update employees
set salary = salary * 1.1
where employee_name LIKE '%Alice' OR salary BETWEEN 2000 and 3500;

-- stock clearance
update books
set price = price * 0.9
where number_of_copies > 45 AND price IS NOT NULL;

-- delete a customer
delete from customers
where customer_name IS NULL OR customer_name = 'Mary Doe';

-- delete an event
delete from events_happening
where event_date > '2025-01-01' OR event_date < '2023-01-01'

-- a)
-- display items available for sale cheaper than 10.99 or where there are less than 10 elems in stock (books and cafe items)
select book_name as 'Items For Sale' from books
where books.price < 10.99 OR books.number_of_copies < 10
union
select cafe_item_name from cafe_items
where cafe_items.price < 10.99 OR cafe_items.number_of_items < 10

-- display items available for sale by J. K. Rowling or published after a certain date, and items that contain Coffee or the price cheaper than 3
select book_name as 'Items For Sale' from books 
where author_id = (select author_id from authors where author_name = 'J.K. Rowling') OR published_date > '2020-01-01'
union
select cafe_item_name from cafe_items
where cafe_item_name LIKE '%Coffee%'  OR price < 3.00;

-- b)
-- customers that ordered both books and cafe items
select customer_id as 'Cafe and Books - CUSTOMER' from book_orders 
intersect 
select customer_id from cafe_orders;

-- customers who have registered for an event and also placed a cafe item order
select customer_id as 'Cafe and Event - CUSTOMER' from cafe_orders
where customer_id in (select customer_id from event_registrations)

-- c)
-- books not ordered by any customer
select book_id as 'Not Ordered Yet' from books
except
select book_id from book_orders

-- cafe items not ordered by any customer
select cafe_item_name as 'Not Ordered Yet' from cafe_items
where cafe_item_id not in (select cafe_item_id from cafe_orders)

-- d)
-- book with their authors
select b.book_id, b.book_name, a.author_name from books b
inner join authors a on b.author_id = a.author_id

-- all customers and their book orders, including no order customers
select distinct c.customer_id, c.customer_name, bo.book_order_id from customers c
left join book_orders bo on c.customer_id = bo.customer_id

-- all employees and the cafe items orders, including no order customers
select distinct c.customer_id, c.customer_name, co.cafe_order_id from cafe_orders co
right join customers c on c.customer_id = co.customer_id

-- customer orders, both books and cafe items
select distinct c.customer_id, c.customer_name, bo.book_order_id, bo.book_id, co.cafe_order_id, co.cafe_item_id from customers c
full join  book_orders bo on c.customer_id = bo.customer_id
full join cafe_orders co on c.customer_id = co.customer_id;

-- e)
-- customers who registered for events
select customer_name from customers
where customer_id in (select customer_id from event_registrations)

-- cafe items ordered by people that attented events
select cafe_item_name from cafe_items 
where cafe_item_id in(
	select cafe_item_id from cafe_orders
	where customer_id in (select customer_id from event_registrations)
)

-- f)
-- customers that ordered books
select customer_name as 'Ordered books' from customers c
where exists (select 1 from book_orders bo where bo.customer_id = c.customer_id)

-- customers that ordered cafe items
select customer_name as 'Ordered Cafe Items' from customers c
where exists (select 1 from cafe_orders co where co.customer_id = c.customer_id)

-- g)
-- average books price
select avg_price.price 
from (select avg(price) as price from books) avg_price

-- average cafe items price
select avg_price.price 
from (select avg(price) as price from cafe_items) avg_price

-- h)
-- count books by genre
select genre_id, count(book_id) as 'Total Books' from books
group by genre_id 
having count(book_id) > 1

-- top 3 most expensive salary paid to employees anually sorted by position
select top 3 poisition, sum(salary)*12 as total_salary from employees
group by poisition
having sum(salary) > 500
order by total_salary desc

-- the author with the most books in our shop since the shop started (2 years ago)
select top 3 author_id, count(book_id)/2 as 'Total Books' from books
group by author_id 
having count(book_id) > 0
order by count(book_id) desc

-- cheapest book by each publisher
select book_publisher_id, min(price) as 'Cheapest' from books
group by book_publisher_id
having min(price) > 0

-- i)
-- cheapest book by author
select book_name, price from books
where price < any (
	select price
	from books as b
	where books.author_id = b.author_id and books.book_id != b.book_id
)
order by price

-- most expensive book in the genre
select genre_id, book_name, price from books
where price > ALL (
	select price
	from books as b
	where books.genre_id = b.genre_id and books.book_id != b.book_id
)
order by genre_id

-- books priced above average of any author
select book_name, price from books
where price > ANY (
	select avg(price) from books
	group by author_id
)

-- books published by authors not found in a specific genre (eg. genre_id = 4, genre_name = fantasy)
select book_name from books 
where author_id not in (
	select author_id from books
	where genre_id = 4
)

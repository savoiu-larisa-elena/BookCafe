-- inserting into the authors table

insert into authors (author_name, date_of_birth, biography) values
('J.K. Rowling', '1965-07-31', 'British author and philanthropist, best known for writing the Harry Potter series.'),
('George Orwell', '1903-06-25', 'English novelist, essayist, journalist, and critic, best known for his novels Animal Farm and 1984.'),
('Jane Austen', '1775-12-16', 'English novelist known primarily for her six major novels, including Pride and Prejudice and Sense and Sensibility.'),
('Mark Twain', '1835-11-30', 'American author and humorist, famous for The Adventures of Tom Sawyer and Adventures of Huckleberry Finn.'),
('Agatha Christie', '1890-09-15', 'English writer known for her 66 detective novels and 14 short story collections, especially those revolving around fictional detectives Hercule Poirot and Miss Marple.'),
('Leo Tolstoy', '1828-09-09', 'Russian author regarded as one of the greatest of all time, best known for his novels War and Peace and Anna Karenina.'),
('Gabriel García Márquez', '1927-03-06', 'Colombian novelist and Nobel Prize winner, renowned for his novel One Hundred Years of Solitude and Love in the Time of Cholera.'),
('Toni Morrison', '1931-02-18', 'American novelist and Nobel Prize winner, recognized for her novels Beloved, The Bluest Eye, and Song of Solomon.'),
('Haruki Murakami', '1949-01-12', 'Japanese novelist and translator, known for his works such as Norwegian Wood and Kafka on the Shore.'),
('Ernest Hemingway', '1899-07-21', 'American novelist and short story writer, famous for works like The Old Man and the Sea, A Farewell to Arms, and For Whom the Bell Tolls.');

delete authors

-- all authors
select *
from authors

-- inserting genres into the genres table
insert into genres (genre_name) values
('Fantasy'),
('Science Fiction'),
('Mystery'),
('Historical Fiction'),
('Romance'),
('Thriller'),
('Horror'),
('Biography'),
('Self-Help'),
('Non-Fiction');

-- all genres
select *
from genres

-- inserting books into the books table
insert into books (title, author_id, genre_id, published_date, price, number_of_copies) values
('Harry Potter and the Chamber of Secrets', 11, 1, '1998-07-02', 29.99, 100),
('The Adventures of Huckleberry Finn', 14, 1, '1884-12-10', 12.99, 40),
('1984', 12, 2, '1949-06-08', 15.99, 50),
('Pride and Prejudice', 13, 5, '1813-01-28', 10.99, 70),
('War and Peace', 16, 4, '1869-01-01', 19.99, 30),
('One Hundred Years of Solitude', 17, 4, '1967-05-30', 14.99, 45),
('Beloved', 18, 5, '1987-09-18', 12.99, 55),
('Murder on the Orient Express', 15, 3, '1934-01-01', 9.99, 60),
('Norwegian Wood', 19, 5, '1987-09-04', 16.99, 80),
('The Old Man and the Sea', 20, 2, '1952-09-01', 11.99, 90);

-- all books
select *
from books

-- inserting customers into the customers table
insert into customers (customer_name) values
('Solomie Rebeca'),
('Sandor Denisa'),
('Secure Diana'),
('Stroia Raluca'),
('Ciobanu Eduarda'),
('Filimon Miruna'),
('Filimon Theona'),
('Margasoiu Ilinca'),
('Cozma Andreea'),
('Vedean Medeea');

-- all customers
select *
from customers

--all employees
select *
from employees

-- insert orders into the orders table
insert into orders (customer_id, employee_id, order_price) values 
(11, 1, 59.97),
(12, 2, 24.99),
(13, 1, 12.99),
(14, 2, 29.98),
(15, 1, 39.97);

-- view all orders
select * 
from orders;

-- insert order details
insert into order_details (order_id, book_id, quantity, price_b_order) values
(4, 21, 2, 37.98),
(5, 22, 1, 17.99);

select *
from order_details

-- insert cafe items
insert into cafe_items (item_name, price) values
('Cappuccino', 4.00),
('Latte', 4.50),
('Croissant', 3.00);

select *
from cafe_items

-- insert cafe orders
insert into cafe_orders (customer_id, employee_id, cafe_order_price) values 
(11, 2, 11.50),
(12, 1, 7.50);

-- insert events
insert into events_happening (event_name, event_date, event_description) values
('Book Signing with Charles Dickens', '2024-11-20', 'Meet the renowned author and get your book signed.'),
('Mystery Book Night', '2024-12-15', 'An evening dedicated to mystery book lovers.');

-- insert registrations
insert into event_registrations (customer_id, event_id) values
(11, 1),
(12, 2);

-- inserting data into the books table (referential integrity should be violated by an invalid author_id)
insert into books (title, author_id, genre_id, published_date, price, number_of_copies)
values ('Invalid Book Example', 999, 1, '2024-01-01', 9.99, 10); -- 999 does not exist in authors table, violates foreign key

-- valid inserts for other tables
insert into customers (customer_name) values ('John Doe');

insert into employees (employee_name, position, salary, email, phone_number, employee_address) 
values ('Susan Johnson', 'Barista', 2450, 'susan.johnson@bookcafe.com', '+40-987654321', '321 Lane Cafe'),
('Alice Johnson', 'Barista', 2500, 'alice.johnson@bookcafe.com', '+40-123456789', '123 Cafe Lane');

insert into cafe_items (item_name, price) values ('Espresso', 3.5);

insert into events_happening (event_name, event_date, event_description) values ('Poetry Night', '2024-11-10', 'A night dedicated to poetry readings and discussions.');

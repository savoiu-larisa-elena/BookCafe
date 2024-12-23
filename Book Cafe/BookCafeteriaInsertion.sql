
-- authors
insert into authors (author_name, date_of_birth, biography) values
('J.K. Rowling', '1965-07-31', 'British author and philanthropist.'),
('George Orwell', '1903-06-25', 'English novelist, essayist, journalist, and critic.'),
('Jane Austen', '1775-12-16', 'English novelist.'),
('Mark Twain', '1835-11-30', 'American author and humorist.'),
('Agatha Christie', '1890-09-15', 'English writer.'),
('Leo Tolstoy', '1828-09-09', 'Russian author regarded as one of the greatest of all time.'),
('Gabriel García Márquez', '1927-03-06', 'Colombian novelist and Nobel Prize winner.'),
('Toni Morrison', '1931-02-18', 'American novelist and Nobel Prize winner.'),
('Haruki Murakami', '1949-01-12', 'Japanese novelist and translator.'),
('Ernest Hemingway', '1899-07-21', 'American novelist and short story writer.');

delete authors

select *
from authors

-- book genres
insert into book_genres(genre_name) values
('Action'),
('Adventure'),
('Biography'),
('Fantasy'),
('Science Fiction'),
('Mystery'),
('Historical Fiction'),
('Romance'),
('Thriller'),
('Horror'),
('Self-Help'),
('Non-Fiction');

delete book_genres

select *
from book_genres

-- book publishers
insert into book_publishers(book_publisher_name, date_founded) values
('Penguin Random House', '2013-07-01'),
('HarperCollins', '1989-05-01'),
('Simon & Schuster', '1924-01-01'),
('Hachette Livre', '1826-01-01'),
('Macmillan Publishers', '1843-01-01'),
('Scholastic Corporation', '1920-10-02'),
('Wiley', '1807-01-01'),
('Oxford University Press', '1586-01-01'),
('Cambridge University Press', '1534-01-01'),
('Bloomsbury Publishing', '1986-04-01');

delete book_publishers

select *
from book_publishers

-- books
insert into books(book_name, author_id, book_publisher_id, genre_id, published_date, number_of_copies, price) values 
('Harry Potter and the Prisoner of Azkaban', 1, 1, 4, '1999-07-08', 70, 19.99),
('And Then There Were None', 5, 5, 6, '1939-11-06', 55, 16.99),
('The Adventures of Tom Sawyer', 4, 4, 2, '1876-06-01', 60, 10.99),
('1984', 2, 2, 6, '1949-06-08', 50, 15.99),
('Beloved', 8, 8, 10, '1987-09-16', 25, 18.99),
('Pride and Prejudice', 3, 3, 9, '1813-01-28', 75, 12.99),
('Murder on the Orient Express', 5, 5, 6, '1934-01-01', 40, 14.99),
('War and Peace', 6, 6, 3, '1869-01-01', 30, 25.99),
('Harry Potter and the Chamber of Secrets', 1, 1, 4, '1998-07-02', 90, 19.99),
('One Hundred Years of Solitude', 7, 7, 5, '1967-05-30', 20, 22.99),
('Norwegian Wood', 9, 9, 5, '1987-09-04', 35, 17.99),
('The Old Man and the Sea', 10, 10, 3, '1952-09-01', 45, 11.99);

delete books

select *
from books

-- cafe items
insert into cafe_items(cafe_item_name, price, number_of_items) values
('Espresso', 2.50, 50),
('Cappuccino', 3.75, 30),
('Latte', 4.00, 25),
('Mocha', 4.50, 20),
('Black Tea', 1.50, 40),
('Herbal Tea', 2.00, 35),
('Croissant', 2.25, 15),
('Chocolate Chip Cookie', 1.75, 50),
('Cheesecake', 3.00, 10),
('Fruit Salad', 2.50, 25);

delete cafe_items

select *
from cafe_items

-- customers
insert into customers(customer_name) values
('Mary Doe'),
('John Doe'),
('Solomie Rebeca'),
('Sandor Denisa'),
('Secure Diana'),
('Stroia Raluca'),
('Ciobanu Eduarda'),
('Filimon Miruna'),
('Filimon Theona'),
('Margasoiu Ilinca'),
('Cozma Andreea'),
('Osanu Gabriela');

delete customers

select *
from customers

-- employees 
insert into employees (employee_name, phone_number, email_address, date_employed, poisition, salary) values
('Alice Johnson', '123-456-7890', 'alice.johnson@gmail.com', '2022-01-15', 'Manager', 4500),
('Bob Smith', '234-567-8901', 'bob.smith@gmail.com', '2023-03-22', 'Barista', 3200),
('Carol White', '345-678-9012', 'carol.white@gmail.com', '2023-05-10', 'Cashier', 2800),
('David Brown', '456-789-0123', 'david.brown@gmail.com', '2022-07-18', 'Sales Associate', 3000),
('Emma Wilson', '567-890-1234', 'emma.wilson@gmail.com', '2024-02-02', 'Barista', 3100),
('Frank Miller', '678-901-2345', 'frank.miller@gmail.com', '2021-11-30', 'Chef', 3500),
('Grace Lee', '789-012-3456', 'grace.lee@gmail.com', '2023-04-20', 'Waitstaff', 2900),
('Hannah Scott', '890-123-4567', 'hannah.scott@gmail.com', '2024-01-05', 'Manager', 4800),
('Ian Young', '901-234-5678', 'ian.young@gmail.com', '2022-06-15', 'Cashier', 2700),
('Jack Wilson', '012-345-6789', 'jack.wilson@gmail.com', '2023-08-30', 'Barista', 3000);

delete employees

select *
from employees

-- book orders
insert into book_orders(customer_id, book_id, employee_id, date_placed) values
(1, 4, 2, '2024-11-02'),
(12, 4, 3, '2024-11-01'),
(1, 1, 2, '2024-11-01'),
(2, 5, 1, '2024-11-02'),
(3, 3, 3, '2024-11-01'),
(4, 7, 4, '2024-11-01'),
(5, 2, 2, '2024-11-03');

delete book_orders

select *
from book_orders

-- cafe orders
insert into cafe_orders(customer_id, cafe_item_id, employee_id, date_placed) values
(1, 3, 2, '2024-11-01'),
(2, 1, 1, '2024-11-02'),
(3, 5, 3, '2024-11-01'),
(4, 4, 4, '2024-11-01'),
(5, 6, 2, '2024-11-03');

delete cafe_orders

select *
from cafe_orders

-- events
insert into events_happening (event_name, event_date, event_description) values
('Book Launch: The New Adventure', '2024-11-01', 'Join us for the launch of the latest adventure novel by a bestselling author.'),
('Café Poetry Night', '2024-10-25', 'An evening of poetry readings from local poets, accompanied by coffee and pastries.'),
('Children’s Storytime', '2024-10-15', 'A fun storytime session for children with storytelling and activities.'),
('Local Author Meet and Greet', '2024-11-05', 'Meet local authors and get your books signed.'),
('Winter Reading Challenge Kick-off', '2024-11-10', 'Join our winter reading challenge and enjoy special prizes for participation!'),
('Café Book Club', '2024-10-20', 'Monthly book club meeting to discuss this month’s chosen book over coffee.'),
('New Year’s Eve Celebration', '2024-12-31', 'Celebrate the New Year with us at a special event featuring live music and food.'),
('Valentine’s Day Special Event', '2025-02-14', 'Enjoy a romantic evening with special discounts on café items for couples.'),
('Spring Book Fair', '2025-04-01', 'Join us for our annual Spring Book Fair with special discounts and author signings.'),
('Summer Reading Program Announcement', '2025-06-01', 'Kick off the summer reading program with fun activities and sign-ups.');

delete events_happening

select *
from events_happening

-- registrations for events
insert into event_registrations (event_id, customer_id) values
(20, 1),  -- Solomie Rebeca registers for event 20
(20, 2),  -- Sandor Denisa registers for event 20
(21, 3),  -- Secure Diana registers for event 21
(21, 4),  -- Stroia Raluca registers for event 21
(22, 5),  -- Ciobanu Eduarda registers for event 22
(22, 6),  -- Filimon Miruna registers for event 22
(23, 7),  -- Filimon Theona registers for event 23
(23, 8);  -- Margasoiu Ilinca registers for event 23

delete event_registrations

select *
from event_registrations

-- suppliers 
insert into suppliers (supplier_name, phone_number) values
('ABC Books Supply', '123-456-7890'),
('Coffee Beans Co.', '234-567-8901'),
('Café Essentials', '345-678-9012'),
('Local Book Store', '456-789-0123'),
('Sweet Treats Bakery', '567-890-1234');

delete suppliers

select *
from suppliers

-- records of supplies
insert into record_supplies (supplier_id, type_supplied) values
(1, 'Books'),         -- ABC Books Supply provides books
(2, 'Cafe Items'),    -- Coffee Beans Co. provides cafe items
(3, 'Cafe Items'),    -- Café Essentials provides cafe items
(1, 'Books'),         -- ABC Books Supply provides more books
(4, 'Books'),         -- Local Book Store provides books
(5, 'Cafe Items');    -- Sweet Treats Bakery provides cafe items

delete record_supplies

select *
from record_supplies


insert into books(book_name, author_id, book_publisher_id, genre_id, published_date, number_of_copies, price) values 
('Error', 100, 100, 100, '2024-11-04', 55, 1) --error

insert into book_orders(customer_id, book_id, employee_id, date_placed) values
(1001, 4, 2, '2024-11-04') --error
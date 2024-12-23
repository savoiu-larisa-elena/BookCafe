/*
Welcome to the Book Cafe!!!

Authors & Books: One author can write many books, but each book belongs to only one author. Each book also falls into a unique genre. 1:m

Customers & Orders: Customers can place multiple orders, be it books or cafe treats, but each order belongs to a single customer. 1:m

Employees & Orders: Our employees can handle many orders, but every order is processed by just one employee. 1:m

Books & Orders: Customers can order multiple books, and each book can appear in many orders. m:n

Cafe Items & Orders: A  selection of cafe items can also be part of any order, and multiple items can be ordered at once! m:n

Events: Customers can attend multiple events, and each event can welcome many guests. m:n

*/

-- Authors table (stores the author of the books contained in the cafe)
create table authors(
	author_id int primary key identity,
	author_name varchar(100) not null,
	date_of_birth date,
	biography varchar(max) not null
);
-- Book genres table (stores the genres of the books available in the cafe)
create table genres(
	genre_id int primary key identity,
	genre_name varchar(100) not null 
);
-- Books table (stores the books in the cafe)
create table books(
	book_id int primary key identity,
	title varchar(100) not null,
	author_id int not null foreign key references authors(author_id) on delete cascade on update cascade,
	genre_id int not null foreign key references genres(genre_id) on delete cascade on update cascade,
	published_date date not null,
	price decimal(10,2) not null,
	number_of_copies int not null,
	unique(author_id, genre_id),
	constraint published_date check (published_date <= getDate())
);
-- Customers table (stores the customers that came in the cafe)
create table customers(
	customer_id int primary key identity,
	customer_name varchar(100) not null,
);
-- Employees table (stores the employees that are working in the cafe)
create table employees(
	employee_id int primary key identity,
	employee_name varchar(100) not null,
    position varchar(50) not null,
    salary decimal(10, 2) not null check (salary >= 0),
    email varchar(200) not null unique,
	phone_number varchar(15) not null, -- there might be a foreign number so we need the prefix, for example the romanian one +40
	employee_address varchar(200) not null
);
-- Orders table (stores information about the books ordered)
create table orders(
	order_id int primary key identity,
	customer_id int not null foreign key references customers(customer_id) on delete cascade on update cascade,
	employee_id int not null foreign key references employees(employee_id) on delete cascade on update cascade,
	order_date datetime default getdate(),
	order_price decimal(10,2) not null check (order_price > 0)
);
-- Order Details table (for many to many relationship between Orders and Books)
create table order_details(
    order_detail_id int primary key identity,
    order_id int not null foreign key references orders(order_id) on delete cascade on update cascade,
    book_id int not null foreign key references books(book_id) on delete cascade on update cascade,
    quantity int not null,
    price_b_order decimal(10,2) not null check (price_b_order > 0)
);

-- CafeItems table (items sold in the cafe, such as coffee, snacks, etc.)
create table cafe_items(
    cafe_item_id int primary key identity,
    item_name varchar(100) not null,
    price decimal(10,2) not null
);

-- CafeOrders table (stores orders of cafe items)
create table cafe_orders(
    cafe_order_id int primary key identity,
    customer_id int not null foreign key references customers(customer_id) on delete cascade on update cascade,
    employee_id int not null foreign key references employees(employee_id) on delete cascade on update cascade,
    order_date datetime default getdate(),
    cafe_order_price decimal(10,2) not null check (cafe_order_price > 0)
);

-- CafeOrderDetails table (for many to many relationship between CafeOrders and CafeItems)
create table cafe_order_details(
    cafe_order_detail int primary key identity,
    cafe_order_id int not null foreign key references cafe_orders(cafe_order_id) on delete cascade on update cascade,
    cafeItemID int not null foreign key references cafe_items(cafe_item_id) on delete cascade on update cascade,
    quantity int not null,
    price_c_order decimal(10,2) not null check (price_c_order > 0)
);

-- Events table
create table events_happening(
    event_id int primary key identity,
    event_name varchar(100) not null,
    event_date datetime not null,
    event_description varchar(max),
);

-- Event registration table
create table event_registrations(
    registration_id int primary key identity,
    customer_id int not null foreign key references customers(customer_id) on delete cascade on update cascade,
    event_id int not null foreign key references events_happening(event_id) on delete cascade on update cascade,
    registration_date datetime default getdate()
);

-- Suppliers table for both books and cafe
create table suppliers(
    supplier_id int primary key identity,
    supplier_name varchar(100) not null,
    contact_person varchar(100),
    phone_number varchar(15),
    email varchar(200) unique not null
);

-- Supplies table 
create table supplies(
    supply_id int primary key identity,
    supplier_id int not null foreign key references suppliers(supplier_id) on delete cascade on update cascade,
    book_id int null foreign key references books(book_id) on delete cascade on update cascade, -- NULL if it's a cafe item
    cafe_item_id int null foreign key references cafe_items(cafe_item_id) on delete cascade on update cascade, -- NULL if it's a book
    supply_date date not null,
    quantity int not null check (quantity > 0),
    constraint ck_supply_item check (
        (book_id is not null and cafe_item_id is null) or
        (book_id is null and cafe_item_id is not null)  -- ensures that either a book or cafe item is supplied, but not both
    )
);

alter table authors
alter column biography varchar(200);

alter table events_happening
alter column event_description varchar(200);
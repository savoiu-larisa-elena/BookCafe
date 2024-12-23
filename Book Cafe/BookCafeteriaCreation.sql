/*
	Welcome to Book Cafeteria!!
	-> one author can write many books, but each book belongs to only one author 1:m
	-> a book can have only one genre, but a genre can contain multiple books 1:m
	-> a customer can place many orders, but each order is handled by one employee 1:m
	-> a book publisher can publish multiper books, but each book belongs to only one book publisher 1:m
	-> each order can contain multiple books, and each book can be in multiple orders n:m
	-> each order can contain multiple cafeteria items, and each cafeteria item can be in multiple orders n:m
	-> each event can have multiple registrations, but each registration is for one event 1:m
	-> each supplier can provide multiple items (books or cafe items), but each supply record is linked to only one supplier 1:m
*/

-- authors table
create table authors(
	author_id int primary key identity(1,1),
	author_name varchar(100) not null,
	date_of_birth date not null,
	biography varchar(150) not null
)

-- book genres table
create table book_genres(
	genre_id int primary key identity(1,1),
	genre_name varchar(50) not null,
)

-- book publishers
create table book_publishers(
	book_publisher_id int primary key identity(1,1),
	book_publisher_name varchar(100) not null,
	date_founded date check (date_founded <= getdate()) not null
)

-- books table
create table books(
	book_id int primary key identity(1,1),
	book_name varchar(200) not null,
	author_id int not null foreign key references authors(author_id) on delete cascade on update cascade,
	genre_id int not null foreign key references book_genres(genre_id) on delete cascade on update cascade,
	book_publisher_id int not null foreign key references book_publishers(book_publisher_id) on delete cascade on update cascade,
	published_date date check (published_date <= getdate()) not null,
	price decimal(10,2) not null check (price > 0),
	number_of_copies int not null
)

-- cafe items table
create table cafe_items(
	cafe_item_id int primary key identity(1,1),
	cafe_item_name varchar(200) not null,
	price decimal(10,2) not null check (price > 0),
	number_of_items int not null
)

-- customers table
create table customers(
	customer_id int primary key identity(1,1),
	customer_name varchar(100) not null
)

-- employees table 
create table employees(
	employee_id int primary key identity(1,1),
	employee_name varchar(100) not null,
	phone_number varchar(15) not null,
	email_address varchar(150) not null,
	date_employed date not null check (date_employed <= getdate()), 
	poisition varchar(100) not null,
	salary int check (salary>=0)
)

-- book orders
create table book_orders(
	book_order_id int primary key identity(1,1),
	customer_id int not null foreign key references customers(customer_id),
	book_id int not null foreign key references books(book_id),
	employee_id int not null foreign key references employees(employee_id),
	date_placed date default getdate()
)

-- cafe orders
create table cafe_orders(
	cafe_order_id int primary key identity(1,1),
	customer_id int not null foreign key references customers(customer_id),
	cafe_item_id int not null foreign key references cafe_items(cafe_item_id),
	employee_id int not null foreign key references employees(employee_id),
	date_placed date default getdate()
)

-- events
create table events_happening (
	event_id int primary key identity(1,1),
	event_name varchar(200) not null,
	event_date date not null check(event_date <= getdate()),
	event_description varchar(200) not null,
	constraint event_date unique (event_date)
)

-- event registrations
create table event_registrations(
	event_registration_id int primary key identity(1,1),
	event_id int not null foreign key references events_happening (event_id),
	customer_id int not null foreign key references customers(customer_id)
)

-- suppliers
create table suppliers(
	supplier_id int primary key identity(1,1),
	supplier_name varchar(100) not null,
	phone_number varchar(15) not null
)

-- record of supplies
create table record_supplies(
	record_supplies_id int primary key identity(1,1),
	supplier_id int not null foreign key references suppliers(supplier_id),
	date_supplied date default getdate(),
	type_supplied varchar(10) not null,
	constraint type_supplied check (type_supplied in ('Books', 'Cafe Items'))
)

alter table events_happening
drop constraint CK__events_ha__event__59FA5E80

use [Book Cafeteria]

-- Drop the existing tables and procedures if they already exist to ensure no conflicts.
DROP TABLE IF EXISTS Book_Authors;
DROP TABLE IF EXISTS Cafe_Orders;
DROP TABLE IF EXISTS Book_Orders;
DROP PROCEDURE IF EXISTS populateTableBookAuthors;
DROP PROCEDURE IF EXISTS populateTableCafeOrders;
DROP PROCEDURE IF EXISTS populateTableBookOrders;
GO

CREATE TABLE Book_Authors (
    author_id INT NOT NULL,  -- Unique identifier for each book author
    author_name VARCHAR(100) NOT NULL, -- Author's name
	ranking INT UNIQUE, -- unique rank
    date_of_birth DATE NOT NULL, -- Author's date of birth
    biography VARCHAR(255), -- Author's biography
    PRIMARY KEY (author_id) -- Primary key on 'author_id'
);
GO

CREATE TABLE CafeO(
    cafe_order_id INT NOT NULL, -- Unique identifier for each cafe order
    customer_id INT NOT NULL, -- Foreign key referencing the customer placing the order
    cafe_item_id INT NOT NULL, -- Foreign key referencing the cafe item ordered
    quantity INT NOT NULL, -- Quantity of the ordered cafe item
    price DECIMAL(10, 2) NOT NULL, -- Total price for this order item
    date_placed DATE DEFAULT GETDATE(), -- Date the order was placed
    PRIMARY KEY (cafe_order_id), -- Primary key on 'cafe_order_id'
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id), -- Foreign key to customers table
    FOREIGN KEY (cafe_item_id) REFERENCES Cafe_Items(cafe_item_id) -- Foreign key to cafe items table
);
GO

-- Table for Book Orders, capturing the books ordered by customers
CREATE TABLE BookO (
    book_order_id INT NOT NULL, -- Unique identifier for each book order
    customer_id INT NOT NULL, -- Foreign key referencing the customer placing the order
    book_id INT NOT NULL, -- Foreign key referencing the book ordered
    quantity INT NOT NULL, -- Quantity of books ordered
    order_date DATE DEFAULT GETDATE(), -- Date the book order was placed
    price DECIMAL(10, 2) NOT NULL, -- Total price for the ordered books
    PRIMARY KEY (book_order_id), -- Primary key on 'book_order_id'
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id), -- Foreign key to customers table
    FOREIGN KEY (book_id) REFERENCES Books(book_id) -- Foreign key to books table
);
GO

drop procedure populateTableBookAuthors
-- Procedure to populate Book_Authors table
CREATE PROCEDURE populateTableBookAuthors(@rows INT) AS
BEGIN
    WHILE @rows > 0 BEGIN
        INSERT INTO Book_Authors(author_id, author_name, ranking, date_of_birth, biography) 
        VALUES (
            @rows, -- 'author_id'
            'Author ' + CAST(@rows AS VARCHAR), -- Generated author name
			@rows,
            DATEADD(YEAR, -@rows, GETDATE()), -- Randomized birthdate
            'Biography of Author ' + CAST(@rows AS VARCHAR) -- Generated biography
        );
        SET @rows = @rows - 1; -- Decrease row count
    END;
END;
GO

-- Procedure to populate Cafe_Orders table
CREATE PROCEDURE populateTableCafeOrders(@rows INT) AS
BEGIN
    WHILE @rows > 0 BEGIN
        INSERT INTO CafeO (cafe_order_id, customer_id, cafe_item_id, quantity, price, date_placed)
        VALUES (
            @rows, -- 'cafe_order_id'
            @rows % 100, -- Random customer_id (cycling through customers)
            @rows % 10, -- Random cafe_item_id (cycling through items)
            @rows % 5 + 1, -- Random quantity between 1 and 5
            5.00 * (@rows % 5 + 1), -- Random price based on quantity
            GETDATE() -- Current date as order date
        );
        SET @rows = @rows - 1; -- Decrease row count
    END;
END;
GO

-- Procedure to populate Book_Orders table
CREATE PROCEDURE populateTableBookOrders(@rows INT) AS
BEGIN
    WHILE @rows > 0 BEGIN
        INSERT INTO BookO (book_order_id, customer_id, book_id, quantity, order_date, price)
        VALUES (
            @rows, -- 'book_order_id'
            @rows % 100, -- Random customer_id (cycling through customers)
            @rows % 50, -- Random book_id (cycling through books)
            @rows % 5 + 1, -- Random quantity between 1 and 5
            GETDATE(), -- Current date as order date
            20.00 * (@rows % 5 + 1) -- Random price based on quantity
        );
        SET @rows = @rows - 1; -- Decrease row count
    END;
END;
GO

-- Execute procedures to populate the tables with data.
EXEC populateTableBookAuthors 100; -- Populate Book_Authors with 100 rows.
EXEC populateTableCafeOrders 200; -- Populate Cafe_Orders with 200 rows.
EXEC populateTableBookOrders 300; -- Populate Book_Orders with 300 rows.
GO

-- Clustered Index Scan
SELECT * 
FROM Book_Authors 
ORDER BY author_id;

-- Clustered Index Seek
SELECT * 
FROM Book_Authors 
WHERE author_id = 10;

-- Nonclustered Index Scan
CREATE NONCLUSTERED INDEX index_author_name 
ON Book_Authors(author_name);

DROP INDEX index_author_name ON Book_Authors

SELECT author_name 
FROM Book_Authors;

-- Nonclustered Index Seek
SELECT author_name 
FROM Book_Authors 
WHERE author_name = 'Author 10';

-- Key Lookup
SELECT author_name, biography, ranking
FROM Book_Authors 
WHERE ranking = '10';

-- b. Write a query on table CafeO with a WHERE clause of the form WHERE quantity = value and analyze its execution plan.

-- Before Creating the Nonclustered Index
SELECT customer_id, price 
FROM CafeO 
WHERE cafe_item_id = 3;

-- Create a Nonclustered Index to Speed Up the Query
CREATE NONCLUSTERED INDEX index_quantity 
ON CafeO(cafe_item_id)
INCLUDE (customer_id, price);

DROP INDEX index_quantity ON CafeO

-- After Creating the Nonclustered Index
SELECT customer_id, price 
FROM CafeO 
WHERE cafe_item_id = 3;

-- Execution Plan Analysis:
-- Clustered Index Scan: ~0.0032831
-- Nonclustered Index Seek: ~0.003125

-- c. Create a view that joins at least 2 tables. Check whether existing indexes are helpful; if not, reassess existing indexes / examine the cardinality of the tables.

CREATE OR ALTER VIEW reviewDetails AS
SELECT c.customer_id, c.cafe_order_id, b.book_id, b.quantity, b.price 
FROM CafeO c
INNER JOIN BookO b ON c.customer_id = b.customer_id;

-- Test whether indexes are helpful
CREATE NONCLUSTERED INDEX index_customer_id 
ON CafeO(customer_id);

CREATE NONCLUSTERED INDEX index_book_id 
ON BookO(book_id);

-- Query the view
SELECT * 
FROM reviewDetails;

-- Drop indexes after testing
DROP INDEX index_customer_id ON CafeO;
DROP INDEX index_book_id ON BookO;

-- Estimated time with nonclustered indexes: ~0.0065
-- Estimated time with no indexes: ~0.024 which is bigger than the time with nonclustered indexes

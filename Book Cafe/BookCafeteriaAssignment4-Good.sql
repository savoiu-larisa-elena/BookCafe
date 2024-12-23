use [Book Cafeteria]

CREATE TABLE Book(
    book_id INT NOT NULL,
    CONSTRAINT PK_Book PRIMARY KEY(book_id)
);

CREATE TABLE Author(
    author_id INT NOT NULL,
    CONSTRAINT PK_Author PRIMARY KEY(author_id),
    book_id INT REFERENCES Book(book_id)
);

CREATE TABLE BorrowTransactions(
    borrower_id INT NOT NULL,
    book_id INT NOT NULL,
    CONSTRAINT PK_BorrowTransactions PRIMARY KEY(borrower_id, book_id)
);

CREATE TABLE BorrowerAux(
    borrower_aux_id INT NOT NULL,
    CONSTRAINT PK_BorrowerAux PRIMARY KEY(borrower_aux_id)
);

-- Insert some data into BorrowerAux table
INSERT INTO BorrowerAux VALUES (1), (2), (3);
GO

-- Create Views for Books, Authors, and BorrowTransactions
CREATE VIEW ViewBooks AS
    SELECT * 
    FROM Book;
GO 

CREATE OR ALTER VIEW ViewAuthors AS
    SELECT Author.author_id
    FROM Author INNER JOIN BorrowTransactions 
        ON Author.book_id = BorrowTransactions.book_id;
GO

CREATE OR ALTER VIEW ViewBorrowTransactions AS
    SELECT BorrowTransactions.borrower_id
    FROM BorrowTransactions INNER JOIN BorrowerAux 
        ON BorrowerAux.borrower_aux_id = BorrowTransactions.borrower_id
    GROUP BY BorrowTransactions.borrower_id;
GO

-- Insert entries for tests
DELETE FROM Tables;
INSERT INTO Tables VALUES('Book'),('Author'),('BorrowTransactions');

DELETE FROM Views;
INSERT INTO Views VALUES ('viewBooks'), ('viewAuthors'), ('viewBorrowTransactions');

DELETE FROM Tests;
INSERT INTO Tests VALUES('selectView'), ('insertBook'), ('deleteBook'), ('insertAuthor'), ('deleteAuthor'), ('insertBorrowTransactions'), ('deleteBorrowTransactions');

SELECT * FROM Tests;
SELECT * FROM Tables;
SELECT * FROM Views;

-- Test View Insertion
DELETE FROM TestViews;
INSERT INTO TestViews VALUES (46, 46), (46, 47), (46, 48);

SELECT * FROM TestViews;

-- (testId, tableId, NoOfRows, Position)
DELETE FROM TestTables;
INSERT INTO TestTables VALUES (47, 6, 100, 1);
INSERT INTO TestTables VALUES (49, 7, 100, 2);
INSERT INTO TestTables VALUES (51, 8, 100, 3);

SELECT * FROM TestTables;
GO

-- Procedures for Insert and Delete Operations
CREATE OR ALTER PROC insertBook 
AS 
    DECLARE @crt INT = 1;
    DECLARE @rows INT;
    SELECT @rows = NoOfRows FROM TestTables WHERE TestId = 2;
    WHILE @crt <= @rows 
    BEGIN 
        INSERT INTO Book VALUES (@crt + 1);
        SET @crt = @crt + 1;
    END;
GO

CREATE OR ALTER PROC deleteBook 
AS 
    DELETE FROM Book WHERE book_id > 1;
GO 

CREATE OR ALTER PROC insertAuthor 
AS 
    DECLARE @crt INT = 1;
    DECLARE @rows INT;
    SELECT @rows = NoOfRows FROM TestTables WHERE TestId = 4;
    WHILE @crt <= @rows 
    BEGIN 
        INSERT INTO Author VALUES (@crt, 1);
        SET @crt = @crt + 1;
    END;
GO 

CREATE OR ALTER PROC deleteAuthor 
AS 
    DELETE FROM Author;
GO

CREATE OR ALTER PROC insertBorrowTransactions 
AS 
    DECLARE @crt INT = 1;
    DECLARE @rows INT;
    SELECT @rows = NoOfRows FROM TestTables WHERE TestId = 6;
    WHILE @crt <= @rows 
    BEGIN 
        INSERT INTO BorrowTransactions VALUES (@crt, @crt);
        SET @crt = @crt + 1;
    END;
GO

CREATE OR ALTER PROC deleteBorrowTransactions 
AS 
    DELETE FROM BorrowTransactions;
GO

-- Test View and Table Runs
CREATE OR ALTER PROC TestRunViewsProc
AS 
    DECLARE @start1 DATETIME;
    DECLARE @start2 DATETIME;
    DECLARE @start3 DATETIME;
    DECLARE @end1 DATETIME;
    DECLARE @end2 DATETIME;
    DECLARE @end3 DATETIME;

    SET @start1 = GETDATE();
    PRINT ('executing select * from Books');
    EXEC ('SELECT * FROM ViewBooks');
    SET @end1 = GETDATE();
    INSERT INTO TestRuns VALUES ('test_view', @start1, @end1);
    INSERT INTO TestRunViews VALUES (@@IDENTITY, 46, @start1, @end1);

    SET @start2 = GETDATE();
    PRINT ('executing select * from Authors');
    EXEC ('SELECT * FROM ViewAuthors');
    SET @end2 = GETDATE();
    INSERT INTO TestRuns VALUES ('test_view2', @start2, @end2);
    INSERT INTO TestRunViews VALUES (@@IDENTITY, 47, @start2, @end2);

    SET @start3 = GETDATE();
    PRINT ('executing select * from BorrowTransactions');
    EXEC ('SELECT * FROM ViewBorrowTransactions');
    SET @end3 = GETDATE();
    INSERT INTO TestRuns VALUES ('test_view3', @start3, @end3);
    INSERT INTO TestRunViews VALUES (@@IDENTITY, 48, @start3, @end3);
GO

CREATE OR ALTER PROC TestRunTablesProc
AS 
    DECLARE @start1 DATETIME;
    DECLARE @start2 DATETIME;
    DECLARE @start3 DATETIME;
    DECLARE @start4 DATETIME;
    DECLARE @start5 DATETIME;
    DECLARE @start6 DATETIME;
    DECLARE @end1 DATETIME;
    DECLARE @end2 DATETIME;
    DECLARE @end3 DATETIME;
    DECLARE @end4 DATETIME;
    DECLARE @end5 DATETIME;
    DECLARE @end6 DATETIME;

    SET @start2 = GETDATE();
    PRINT('deleting data from Book');
    EXEC deleteBook;
    SET @end2 = GETDATE();
    INSERT INTO TestRuns VALUES ('test_delete_book', @start2, @end2);
    INSERT INTO TestRunTables VALUES (@@IDENTITY, 6, @start2, @end2);

    SET @start1 = GETDATE();
    PRINT('inserting data into Book');
    EXEC insertBook;
    SET @end1 = GETDATE();
    INSERT INTO TestRuns VALUES ('test_insert_book', @start1, @end1);
    INSERT INTO TestRunTables VALUES (@@IDENTITY, 6, @start1, @end1);

    SET @start4 = GETDATE();
    PRINT('deleting data from Author');
    EXEC deleteAuthor;
    SET @end4 = GETDATE();
    INSERT INTO TestRuns VALUES ('test_delete_author', @start4, @end4);
    INSERT INTO TestRunTables VALUES (@@IDENTITY, 7, @start4, @end4);

    SET @start3 = GETDATE();
    PRINT('inserting data into Author');
    EXEC insertAuthor;
    SET @end3 = GETDATE();
    INSERT INTO TestRuns VALUES ('test_insert_author', @start3, @end3);
    INSERT INTO TestRunTables VALUES (@@IDENTITY, 7, @start3, @end3);

    SET @start6 = GETDATE();
    PRINT('deleting data from BorrowTransactions');
    EXEC deleteBorrowTransactions;
    SET @end6 = GETDATE();
    INSERT INTO TestRuns VALUES ('test_delete_borrow_transactions', @start6, @end6);
    INSERT INTO TestRunTables VALUES (@@IDENTITY, 8, @start6, @end6);

    SET @start5 = GETDATE();
    PRINT('inserting data into BorrowTransactions');
    EXEC insertBorrowTransactions;
    SET @end5 = GETDATE();
    INSERT INTO TestRuns VALUES ('test_insert_borrow_transactions', @start5, @end5);
    INSERT INTO TestRunTables VALUES (@@IDENTITY, 8, @start5, @end5);
GO

-- Execute the procedures to run tests
EXEC TestRunTablesProc;
EXEC TestRunViewsProc;

-- View the results of the tests
SELECT * FROM TestRuns;
SELECT * FROM TestRunViews;
SELECT * FROM TestRunTables;

-- Clean up tables and reset the data for the next tests
DELETE FROM Book;
DELETE FROM Author;
DELETE FROM BorrowTransactions;

DELETE FROM TestTables;
INSERT INTO TestTables VALUES (2, 7, 100, 1);
INSERT INTO TestTables VALUES (4, 8, 100, 2);
INSERT INTO TestTables VALUES (6, 9, 100, 3);

DELETE FROM TestRunViews;
DELETE FROM TestRunTables;
DELETE FROM TestRuns;

SELECT * FROM Book;

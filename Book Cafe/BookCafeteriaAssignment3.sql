use [Book Cafeteria]

-- memorates all the version of the table
create table version_changer (
	version_number int unique not null,
	description_v varchar(255)
);


-- upgrade and revert versions for each assignment

-- 1.
-- modify the type of a column (book_name)
create procedure upgrade_varchar_nvarchar_books as 
begin
	alter table books alter column book_name NVARCHAR(255); -- from varchar to nvarchar to be able to use a range of another letters and special symbols
	insert into version_changer (version_number, description_v)
	values (1, 'Change column type of book_name from varchar to nvarchar');
end;
go

-- revert the modification
create procedure revert_varchar_nvarchar_books as
begin
	alter table books alter column book_name VARCHAR(200);
	delete from version_changer where version_number = 1;
end;
go

-- 2.
-- add a column
create procedure upgrade_adding_a_column_customers as
begin
	alter table customers add email_address varchar(150);
	insert into version_changer (version_number, description_v)
	values (2, 'Adds a new column in customer to store their emails');
end;
go

-- revert (deletes the column)
create procedure revert_adding_a_column_customers as
begin 
	alter table customers drop column email_address;
	delete from version_changer where version_number = 2;
end;
go

-- 3.
-- add a default constraint 
create procedure upgrade_df_constraint_cafe as
begin
	alter table cafe_items add constraint price default 2.0 for price;
	insert into version_changer (version_number, description_v)
	values (3, 'Adds a default constraint for price in cafe_items');
end;
go

-- revert (deletes the constraint)
create procedure revert_df_constraint_cafe as
begin
	alter table cafe_items drop constraint price;
	delete from version_changer where version_number = 3;
end;
go

-- 4.
-- adds a primary key to a table
create procedure upgrade_primary_key_v_changer as
begin 
    alter table version_changer
    add constraint pk_v_changer primary key (version_number);
    
    insert into version_changer (version_number, description_v)
    values (4, 'Adds a primary key to version changer');
end;
go

-- revert
create procedure revert_primary_key_v_changer as
begin 
    alter table version_changer
    drop constraint if exists pk_v_changer;
    
    delete from version_changer where version_number = 4;
end;
go



-- 5.
-- adds a candidate key to a table
create procedure upgrade_candidate_key_employee as
begin 
	alter table employees add constraint ck_email unique (email_address);
	insert into version_changer (version_number, description_v)
	values (5, 'Adds a candidate key to employee email');
end;
go

-- revert (deletes the key)
create procedure revert_candidate_key_employee as
begin 
	 alter table employees drop constraint ck_email;
	 delete from version_changer where version_number = 5;
end;
go

-- 6.
-- adds a foreign key to a table
create procedure upgrade_foreign_key_books as
begin 
	alter table book_orders add constraint fk_book_order_employee foreign key (employee_id) references employees(employee_id);
	insert into version_changer (version_number, description_v)
	values (6, 'Adds a foreign key to book orders');
end;
go

-- revert (deletes the key) 
create procedure revert_foreign_key_books as
begin 
	alter table book_orders drop constraint fk_book_order_employee;
	delete from version_changer where version_number = 6;
end;
go

-- 7.
-- create an additional table with memberships
create procedure upgrade_create_table as
begin
	create table memberships(
		mem_id int primary key identity(1,1),
		customer_id int not null foreign key references customers(customer_id),
		mem_type VARCHAR(50) not null,
		mem_start date not null,
		mem_end date
	);
	insert into version_changer (version_number, description_v)
	values (7, 'Adds a new table with memberships');
end;
go

-- revert (delets the key)
create procedure revert_create_table as
begin
	drop table memberships;
	delete from version_changer where version_number = 7;
end;
go

-- the stored procedure to set the database version
create procedure set_version_db(@target_version int)
as
begin
	if @target_version > 7
    begin
        raiserror('Target version cannot be greater than 7.', 16, 1);
        return;
    end

    declare @current_version int;

    -- get the current version of the database
    select @current_version = max(version_number) from version_changer;

	if @current_version is NULL
    begin
        set @current_version = 0;
    end

    -- upgrade the database
    while @current_version < @target_version
    begin
        set @current_version = @current_version + 1;

        -- create a dynamic SQL query for upgrade procedures
        declare @sql_upgrade nvarchar(max);

        if @current_version = 1 
            set @sql_upgrade = 'exec upgrade_varchar_nvarchar_books';
        if @current_version = 2 
            set @sql_upgrade = 'exec upgrade_adding_a_column_customers';
        if @current_version = 3 
            set @sql_upgrade = 'exec upgrade_df_constraint_cafe';
        if @current_version = 4 
            set @sql_upgrade = 'exec upgrade_primary_key_v_changer';
        if @current_version = 5 
            set @sql_upgrade = 'exec upgrade_candidate_key_employee';
        if @current_version = 6 
            set @sql_upgrade = 'exec upgrade_foreign_key_books';
        if @current_version = 7 
            set @sql_upgrade = 'exec upgrade_create_table';
        
        -- Execute the upgrade procedure dynamically
        exec sp_executesql @sql_upgrade;
    end;

    -- downgrade the database
    while @current_version > @target_version
    begin

        -- Create a dynamic SQL query for revert procedures
        declare @sql_revert nvarchar(max);

        if @current_version = 7 
            set @sql_revert = 'exec revert_create_table';
        if @current_version = 6 
            set @sql_revert = 'exec revert_foreign_key_books';
        if @current_version = 5 
            set @sql_revert = 'exec revert_candidate_key_employee';
        if @current_version = 4 
            set @sql_revert = 'exec revert_primary_key_v_changer';
        if @current_version = 3 
            set @sql_revert = 'exec revert_df_constraint_cafe';
        if @current_version = 2 
            set @sql_revert = 'exec revert_adding_a_column_customers';
        if @current_version = 1 
            set @sql_revert = 'exec revert_varchar_nvarchar_books';

		set @current_version = @current_version - 1;

        -- Execute the revert procedure dynamically
        exec sp_executesql @sql_revert;
    end;
end;

if not exists (select 1 from version_changer)
begin 
	insert into version_changer(version_number, description_v)
	values(0, 'initial version');
end;

exec set_version_db 0;

select max(version_number) as current_version from version_changer;

drop procedure upgrade_adding_a_column_customers
drop procedure upgrade_candidate_key_employee
drop procedure upgrade_create_table
drop procedure upgrade_df_constraint_cafe
drop procedure upgrade_foreign_key_books
drop procedure upgrade_primary_key_v_changer
drop procedure upgrade_varchar_nvarchar_books
drop procedure set_version_db
drop procedure revert_adding_a_column_customers
drop procedure revert_candidate_key_employee
drop procedure revert_create_table
drop procedure revert_df_constraint_cafe
drop procedure revert_foreign_key_books
drop procedure revert_primary_key_v_changer
drop procedure revert_varchar_nvarchar_books
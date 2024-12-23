--sps
use desafio360
GO
-- Stored Procedure to Insert a State with state_id always set to 'ACTIVO' and validate created_by is OPERATOR
CREATE PROCEDURE SALES.insert_state
    @id VARCHAR(64),
    @isEnabled BIT,
    @created_by INT
AS
BEGIN
    -- Check if the created_by user exists in USERS table and has the role 'OPERATOR'
    IF NOT EXISTS (SELECT 1 FROM SALES.USERS WHERE id = @created_by AND role_id = (SELECT id FROM SALES.ROLES WHERE name = 'OPERATOR'))
    BEGIN
        RAISERROR('Created By user does not have the role OPERATOR.', 16, 1);
        RETURN;
    END

    -- Check if state with the given ID already exists
    IF EXISTS (SELECT 1 FROM SALES.STATES WHERE id = @id)
    BEGIN
        RAISERROR('State with the specified ID already exists.', 16, 1);
        RETURN;
    END

    -- Insert new state with state_id always set to 'ACTIVO'
    INSERT INTO SALES.STATES (id, isEnabled, created_by, created_at)
    VALUES (@id, @isEnabled, @created_by, GETDATE());
END;
GO

-- Stored Procedure to Update a State (created_by and created_at are never updated, state_id is not updated)
CREATE PROCEDURE SALES.update_state
    @id VARCHAR(64),
    @isEnabled BIT,
    @created_by INT
AS
BEGIN
    -- Check if the state exists
    IF NOT EXISTS (SELECT 1 FROM SALES.STATES WHERE id = @id)
    BEGIN
        RAISERROR('State with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    -- Update existing state but prevent created_by and created_at from being updated
    UPDATE SALES.STATES
    SET
        isEnabled = @isEnabled,
        created_by = (SELECT id FROM SALES.USERS WHERE role_id = 2)  -- Set created_by to user with OPERATOR role (role_id = 2)
        
    WHERE id = @id;
END;
GO


-- Stored Procedure to Insert a Role with state_id always set to 'ACTIVO' and validate created_by is OPERATOR

CREATE PROCEDURE SALES.insert_role
    @name VARCHAR(64),
    @created_by INT
AS
BEGIN
    -- Check if the created_by user exists in USERS table and has the role 'OPERATOR'
    IF NOT EXISTS (SELECT 1 FROM SALES.USERS WHERE id = @created_by AND role_id = (SELECT id FROM SALES.ROLES WHERE name = 'OPERATOR'))
    BEGIN
        RAISERROR('Created By user does not have the role OPERATOR.', 16, 1);
        RETURN;
    END

    -- Check if a role with the given name already exists
    IF EXISTS (SELECT 1 FROM SALES.ROLES WHERE name = @name)
    BEGIN
        RAISERROR('Role with the specified name already exists.', 16, 1);
        RETURN;
    END

    -- Insert new role with state_id always set to 'ACTIVO'
    INSERT INTO SALES.ROLES (name, state_id, created_by, created_at)
    VALUES (@name, 'ACTIVO', @created_by, GETDATE());
END;
GO


-- Stored Procedure to Update a Role (created_by and created_at are never updated, state_id is not updated)
CREATE PROCEDURE SALES.update_role
    @id INT, 
    @name VARCHAR(64)
AS
BEGIN
    -- Check if the role exists
    IF NOT EXISTS (SELECT 1 FROM SALES.ROLES WHERE id = @id)
    BEGIN
        RAISERROR('Role with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    -- Update existing role but prevent created_by and created_at from being updated
    UPDATE SALES.ROLES
    SET
        name = @name,
        created_by = (SELECT id FROM SALES.USERS WHERE role_id = 2)  -- Set created_by to the user with the 'OPERATOR' role (role_id = 2)        
    WHERE id = @id;
END;
GO


-- Stored Procedure to Insert a User where role_id is copied from the created_by user's role




CREATE PROCEDURE SALES.insert_user
    @email VARCHAR(256),
    @phone_number VARCHAR(32),
    @date_of_birth DATE,
    @password varchar(256),
    @role_id int,
    @created_by INT
AS
BEGIN
    declare @newId int;
    -- Check if the created_by user exists in USERS table
    IF NOT EXISTS (SELECT 1 FROM SALES.USERS WHERE id = @created_by)
    BEGIN
        RAISERROR('Created By user does not exist in USERS table.', 16, 1);
        RETURN;
    END

    -- Get the role_id of the created_by user
    --DECLARE @role_id INT;
    --SELECT @role_id = role_id FROM SALES.USERS WHERE id = @created_by;

    IF EXISTS (SELECT 1 FROM SALES.USERS WHERE EMAIL = @email and state_id = 'ACTIVO')
    BEGIN
        RAISERROR('Email is already in use', 16, 1)
        RETURN;
    END

    -- Insert new user with the role_id copied from the created_by user
    INSERT INTO SALES.USERS (role_id, state_id, email, password, phone_number, date_of_birth, created_by, created_at)
    VALUES (@role_id, 'ACTIVO', @email, @password , @phone_number, @date_of_birth, @created_by, GETDATE());
    set @newId = SCOPE_IDENTITY();
    select @newId as id
END;
GO


-- Stored Procedure to Update a User (role_id and password are never updated)
CREATE PROCEDURE SALES.update_user
    @id INT,
    @email VARCHAR(256),
    @phone_number VARCHAR(32),
    @date_of_birth DATE
AS
BEGIN
    -- Check if the user exists
    IF NOT EXISTS (SELECT 1 FROM SALES.USERS WHERE id = @id)
    BEGIN
        RAISERROR('User with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    -- Update user but prevent role_id and password from being updated
    UPDATE SALES.USERS
    SET
        email = @email,
        phone_number = @phone_number,
        date_of_birth = @date_of_birth
    WHERE id = @id;
END;
GO


-- Stored Procedure to Insert Shipping Information with state_id always set to 'ACTIVO'


CREATE PROCEDURE SALES.insert_shipping_information
    @legal_name VARCHAR(128),
    @trade_name VARCHAR(128),
    @shipping_address VARCHAR(64),
    @phone_number VARCHAR(32),
    @email VARCHAR(256),
    @user_id INT,
    @created_by INT
AS
BEGIN
    declare @newId int;
    -- Check if the created_by user exists in USERS table
    IF NOT EXISTS (SELECT 1 FROM SALES.USERS WHERE id = @created_by)
    BEGIN
        RAISERROR('Created By user does not exist in USERS table.', 16, 1);
        RETURN;
    END

    -- Check if the user_id exists in USERS table
    IF NOT EXISTS (SELECT 1 FROM SALES.USERS WHERE id = @user_id)
    BEGIN
        RAISERROR('User with the specified user_id does not exist in USERS table.', 16, 1);
        RETURN;
    END

    -- Insert Shipping Information with state_id always set to 'ACTIVO'
    INSERT INTO SALES.SHIPPING_INFORMATION (legal_name, trade_name, shipping_address, phone_number, email, user_id, state_id, created_by, created_at)
    VALUES (@legal_name, @trade_name, @shipping_address, @phone_number, @email, @user_id, 'ACTIVO', @created_by, GETDATE());

    set @newId = SCOPE_IDENTITY();
    select @newId as id;
END;
GO


-- Stored Procedure to Update Shipping Information (created_by and created_at are never updated)

CREATE PROCEDURE SALES.update_shipping_information
    @id INT,
    @legal_name VARCHAR(128),
    @trade_name VARCHAR(128),
    @shipping_address VARCHAR(64),
    @phone_number VARCHAR(32),
    @email VARCHAR(256)
AS
BEGIN
    -- Check if the shipping information exists
    IF NOT EXISTS (SELECT 1 FROM SALES.SHIPPING_INFORMATION WHERE id = @id)
    BEGIN
        RAISERROR('Shipping Information with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    
    
    -- Update shipping information but prevent created_by and created_at from being updated
    UPDATE SALES.SHIPPING_INFORMATION
    SET
        legal_name = @legal_name,
        trade_name = @trade_name,
        shipping_address = @shipping_address,
        phone_number = @phone_number,
        email = @email
    WHERE id = @id;
END;
GO


-----------------------
-----------------------
-----------------------
-- Stored Procedure to Insert a Product with state_id always set to 'ACTIVO' and role validation for OPERATOR

CREATE PROCEDURE SALES.insert_product
    @name VARCHAR(64),
    @brand VARCHAR(64),
    @code VARCHAR(64),
    @photo VARBINARY(MAX),  -- Photo as binary data
    @created_by INT
AS
BEGIN
	declare @product_id int;
    -- Check if the created_by user exists in USERS table
    IF NOT EXISTS (SELECT 1 FROM SALES.USERS WHERE id = @created_by)
    BEGIN
        RAISERROR('Created By user does not exist in USERS table.', 16, 1);
        RETURN;
    END

    -- Validate the created_by user's role (must be OPERATOR)
    DECLARE @role_id INT;
    SELECT @role_id = role_id FROM SALES.USERS WHERE id = @created_by;

    IF NOT EXISTS (SELECT 1 FROM SALES.ROLES WHERE id = @role_id AND name = 'OPERATOR')
    BEGIN
        RAISERROR('User does not have the OPERATOR role to create a product.', 16, 1);
        RETURN;
    END

    -- Insert product with state_id always set to 'ACTIVO'
    INSERT INTO SALES.PRODUCTS (name, brand, code, photo, state_id, created_by, created_at)
    VALUES (@name, @brand, @code, @photo, 'ACTIVO', @created_by, GETDATE());
   	set @product_id = SCOPE_IDENTITY();
   select @product_id as id
END;
GO

-- Stored Procedure to Update a Product (created_by and created_at are never updated) with role validation for OPERATOR
CREATE PROCEDURE SALES.update_product
    @id INT,
    @name VARCHAR(64),
    @brand VARCHAR(64),
    @code VARCHAR(64),
    @photo VARBINARY(MAX)  -- Photo as binary data
AS
BEGIN
    -- Check if the product exists
    IF NOT EXISTS (SELECT 1 FROM SALES.PRODUCTS WHERE id = @id)
    BEGIN
        RAISERROR('Product with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    -- Check if the user exists
    DECLARE @created_by INT;
    SELECT @created_by = created_by FROM SALES.PRODUCTS WHERE id = @id;

    -- Validate the created_by user's role (must be OPERATOR)
    DECLARE @role_id INT;
    SELECT @role_id = role_id FROM SALES.USERS WHERE id = @created_by;

    IF NOT EXISTS (SELECT 1 FROM SALES.ROLES WHERE id = @role_id AND name = 'OPERATOR')
    BEGIN
        RAISERROR('User does not have the OPERATOR role to update the product.', 16, 1);
        RETURN;
    END

    -- Update product but prevent created_by and created_at from being updated
    UPDATE SALES.PRODUCTS
    SET
        name = @name,
        brand = @brand,
        code = @code,
        photo = ISNULL(@photo, photo)
    WHERE id = @id;
END;
GO


-- Stored Procedure to Insert a Product Stock with role validation for OPERATOR
CREATE PROCEDURE SALES.insert_product_stock
    @product_id INT,
    @purchase_price MONEY,
    @created_by INT
AS
BEGIN
    -- Check if the created_by user exists in USERS table
    IF NOT EXISTS (SELECT 1 FROM SALES.USERS WHERE id = @created_by)
    BEGIN
        RAISERROR('Created By user does not exist in USERS table.', 16, 1);
        RETURN;
    END

    -- Validate the created_by user's role (must be OPERATOR)
    DECLARE @role_id INT;
    SELECT @role_id = role_id FROM SALES.USERS WHERE id = @created_by;

    IF NOT EXISTS (SELECT 1 FROM SALES.ROLES WHERE id = @role_id AND name = 'OPERATOR')
    BEGIN
        RAISERROR('User does not have the OPERATOR role to create product stock.', 16, 1);
        RETURN;
    END

    -- Check if the product exists in the PRODUCTS table
    IF NOT EXISTS (SELECT 1 FROM SALES.PRODUCTS WHERE id = @product_id)
    BEGIN
        RAISERROR('Product does not exist in the PRODUCTS table.', 16, 1);
        RETURN;
    END

    -- Insert product stock record with state_id and created_by
    INSERT INTO SALES.PRODUCTS_STOCK (product_id, purchase_price, state_id, created_by, created_at)
    VALUES (@product_id, @purchase_price, 'ACTIVO', @created_by, GETDATE());
END;
GO

-- Stored Procedure to Update a Product Stock (created_by and created_at are never updated) with role validation for OPERATOR
CREATE PROCEDURE SALES.update_product_stock
    @id INT,
    @product_id INT,
    @purchase_price MONEY
AS
BEGIN
    -- Check if the product stock exists
    IF NOT EXISTS (SELECT 1 FROM SALES.PRODUCTS_STOCK WHERE id = @id)
    BEGIN
        RAISERROR('Product Stock with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    -- Check if the user exists
    DECLARE @created_by INT;
    SELECT @created_by = created_by FROM SALES.PRODUCTS_STOCK WHERE id = @id;

    -- Validate the created_by user's role (must be OPERATOR)
    DECLARE @role_id INT;
    SELECT @role_id = role_id FROM SALES.USERS WHERE id = @created_by;

    IF NOT EXISTS (SELECT 1 FROM SALES.ROLES WHERE id = @role_id AND name = 'OPERATOR')
    BEGIN
        RAISERROR('User does not have the OPERATOR role to update product stock.', 16, 1);
        RETURN;
    END

    -- Check if the product exists in the PRODUCTS table
    IF NOT EXISTS (SELECT 1 FROM SALES.PRODUCTS WHERE id = @product_id)
    BEGIN
        RAISERROR('Product does not exist in the PRODUCTS table.', 16, 1);
        RETURN;
    END

    -- Update product stock but prevent created_by and created_at from being updated
    UPDATE SALES.PRODUCTS_STOCK
    SET
        product_id = @product_id,
        purchase_price = @purchase_price
    WHERE id = @id;
END;
GO


-- Stored Procedure to Insert a Category with role validation for OPERATOR

CREATE PROCEDURE SALES.insert_category
    @name VARCHAR(32),
    @created_by INT
AS
BEGIN
    DECLARE @newId int;
    -- Check if the created_by user exists in USERS table
    IF NOT EXISTS (SELECT 1 FROM SALES.USERS WHERE id = @created_by)
    BEGIN
        RAISERROR('Created By user does not exist in USERS table.', 16, 1);
        RETURN;
    END

    -- Validate the created_by user's role (must be OPERATOR)
    DECLARE @role_id INT;
    SELECT @role_id = role_id FROM SALES.USERS WHERE id = @created_by;

    IF NOT EXISTS (SELECT 1 FROM SALES.ROLES WHERE id = @role_id AND name = 'OPERATOR')
    BEGIN
        RAISERROR('User does not have the OPERATOR role to create a category.', 16, 1);
        RETURN;
    END

    -- Insert category record with state_id always set to 'ACTIVO'
    INSERT INTO SALES.CATEGORIES (name, state_id, created_by, created_at)
    VALUES (@name, 'ACTIVO', @created_by, GETDATE());

    set @newId = SCOPE_IDENTITY();
    select @newId as id
END;
GO


-- Stored Procedure to Update a Category (created_by and created_at are never updated) with role validation for OPERATOR


CREATE PROCEDURE SALES.update_category
    @id INT,
    @name VARCHAR(32)
AS
BEGIN    
    -- Check if the category exists
    IF NOT EXISTS (SELECT 1 FROM SALES.CATEGORIES WHERE id = @id)
    BEGIN
        RAISERROR('Category with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    -- Check if the user exists
    DECLARE @created_by INT;
    SELECT @created_by = created_by FROM SALES.CATEGORIES WHERE id = @id;

    -- Validate the created_by user's role (must be OPERATOR)
    DECLARE @role_id INT;
    SELECT @role_id = role_id FROM SALES.USERS WHERE id = @created_by;

    IF NOT EXISTS (SELECT 1 FROM SALES.ROLES WHERE id = @role_id AND name = 'OPERATOR')
    BEGIN
        RAISERROR('User does not have the OPERATOR role to update the category.', 16, 1);
        RETURN;
    END

    -- Update category but prevent created_by and created_at from being updated
    UPDATE SALES.CATEGORIES
    SET
        name = @name
    WHERE id = @id;
END;
GO

-- Stored Procedure to Insert a Category-Product association with role validation for OPERATOR
CREATE PROCEDURE SALES.insert_category_product
    @product_id INT,
    @category_id INT,
    @created_by INT
AS
BEGIN
    -- Check if the created_by user exists in USERS table
    IF NOT EXISTS (SELECT 1 FROM SALES.USERS WHERE id = @created_by)
    BEGIN
        RAISERROR('Created By user does not exist in USERS table.', 16, 1);
        RETURN;
    END

    -- Validate the created_by user's role (must be OPERATOR)
    DECLARE @role_id INT;
    SELECT @role_id = role_id FROM SALES.USERS WHERE id = @created_by;

    IF NOT EXISTS (SELECT 1 FROM SALES.ROLES WHERE id = @role_id AND name = 'OPERATOR')
    BEGIN
        RAISERROR('User does not have the OPERATOR role to create a category-product association.', 16, 1);
        RETURN;
    END

    -- Check if the product exists in the PRODUCTS table
    IF NOT EXISTS (SELECT 1 FROM SALES.PRODUCTS WHERE id = @product_id)
    BEGIN
        RAISERROR('Product does not exist in the PRODUCTS table.', 16, 1);
        RETURN;
    END

    -- Check if the category exists in the CATETORIES table
    IF NOT EXISTS (SELECT 1 FROM SALES.CATETORIES WHERE id = @category_id)
    BEGIN
        RAISERROR('Category does not exist in the CATETORIES table.', 16, 1);
        RETURN;
    END

    -- Insert category-product association record with state_id always set to 'ACTIVO'
    INSERT INTO SALES.CATEGORIES_PRODUCTS (product_id, category_id, state_id, created_by, created_at)
    VALUES (@product_id, @category_id, 'ACTIVO', @created_by, GETDATE());
END;
GO



-- Stored Procedure to Insert an Order State with role validation for OPERATOR
CREATE PROCEDURE SALES.insert_order_state
    @id VARCHAR(64),
    @state_id VARCHAR(64),
    @created_by INT
AS
BEGIN
    -- Check if the created_by user exists in USERS table
    IF NOT EXISTS (SELECT 1 FROM SALES.USERS WHERE id = @created_by)
    BEGIN
        RAISERROR('Created By user does not exist in USERS table.', 16, 1);
        RETURN;
    END

    -- Validate the created_by user's role (must be OPERATOR)
    DECLARE @role_id INT;
    SELECT @role_id = role_id FROM SALES.USERS WHERE id = @created_by;

    IF NOT EXISTS (SELECT 1 FROM SALES.ROLES WHERE id = @role_id AND name = 'OPERATOR')
    BEGIN
        RAISERROR('User does not have the OPERATOR role to create an order state.', 16, 1);
        RETURN;
    END

    -- Insert order state with state_id always set to 'ACTIVO'
    INSERT INTO SALES.ORDERS_STATES (id, state_id, created_by, created_at)
    VALUES (@id, 'ACTIVO', @created_by, GETDATE());
END;
GO


-- Stored Procedure to Insert an Order with role validation for OPERATOR



CREATE PROCEDURE SALES.insert_order
    @client_id INT,
    @estimated_delivery_date DATETIME,
    @delivery_date DATETIME,
    @order_state_id VARCHAR(64),
    @created_by INT
AS
BEGIN
    declare @newid int;
   
    
    -- Check if the created_by user exists in USERS table
    IF NOT EXISTS (SELECT 1 FROM SALES.USERS WHERE id = @created_by)
    BEGIN
        RAISERROR('Created By user does not exist in USERS table.', 16, 1);
        RETURN;
    END

    -- Validate the created_by user's role (must be OPERATOR)
    DECLARE @role_id INT;
    SELECT @role_id = role_id FROM SALES.USERS  u
    	join sales.SHIPPING_INFORMATION si  
    		on u.id = si.user_id
   		WHERE si.id  = @client_id;

    IF NOT EXISTS (SELECT 1 FROM SALES.ROLES WHERE id = @role_id AND name = 'CLIENT')
    BEGIN
        RAISERROR('User does not have the CLIENT role to create an order.', 16, 1);
        RETURN;
    END

    -- Insert the order record with state_id always set to 'ACTIVO'
    INSERT INTO SALES.ORDERS (client_id, estimated_delivery_date, delivery_date, order_state_id, created_by, created_at)
    VALUES (@client_id, @estimated_delivery_date, @delivery_date, @order_state_id, @created_by, GETDATE());

    set @newid = SCOPE_IDENTITY();
    select @newid as id;
END;
GO

-- Stored Procedure to Update an Order (client_id cannot be updated) with role validation for OPERATOR
CREATE PROCEDURE SALES.update_order
    @id INT,
    @estimated_delivery_date DATETIME,
    @delivery_date DATETIME,
    @created_by INT
AS
BEGIN
    -- Check if the order exists with the provided id
    IF NOT EXISTS (SELECT 1 FROM SALES.ORDERS WHERE id = @id)
    BEGIN
        RAISERROR('Order with the specified id does not exist.', 16, 1);
        RETURN;
    END

    -- Check if the user exists
    DECLARE @role_id INT;
    SELECT @role_id = role_id FROM SALES.USERS WHERE id = @created_by;

    -- Validate the created_by user's role (must be OPERATOR)
    IF NOT EXISTS (SELECT 1 FROM SALES.ROLES WHERE id = @role_id AND name = 'OPERATOR')
    BEGIN
        RAISERROR('User does not have the OPERATOR role to update the order.', 16, 1);
        RETURN;
    END

    -- Update the order record but prevent client_id from being updated
    UPDATE SALES.ORDERS
    SET
        estimated_delivery_date = @estimated_delivery_date,
        delivery_date = @delivery_date
    WHERE id = @id;
END;
GO

-- Stored Procedure to Insert Order Details with role validation for OPERATOR
CREATE PROCEDURE SALES.insert_order_details
    @order_id INT,
    @quantity INT,
    @tax_rate INT,
    @sell_price MONEY,
    @product_id INT,
    @created_by INT
AS
BEGIN
    declare @newId int;
    -- Check if the order exists with the provided order_id
    IF NOT EXISTS (SELECT 1 FROM SALES.ORDERS WHERE id = @order_id)
    BEGIN
        RAISERROR('Order with the specified id does not exist.', 16, 1);
        RETURN;
    END

    -- Check if the created_by user exists in USERS table
    IF NOT EXISTS (SELECT 1 FROM SALES.USERS WHERE id = @created_by)
    BEGIN
        RAISERROR('Created By user does not exist in USERS table.', 16, 1);
        RETURN;
    END

    -- Validate the created_by user's role (must be OPERATOR)
    DECLARE @role_id INT;
    SELECT @role_id = role_id FROM SALES.USERS WHERE id = @created_by;

    IF NOT EXISTS (SELECT 1 FROM SALES.ROLES WHERE id = @role_id AND name = 'CLIENT')
    BEGIN
        RAISERROR('User does not have the CLIENT role to insert order details.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM SALES.PRODUCTS WHERE id = @product_id)
    BEGIN
        RAISERROR('Product does not exists.', 16, 1);
        RETURN;
    END

    -- Validate that quantity, tax_rate, and sell_price are valid
    IF @quantity <= 0
    BEGIN
        RAISERROR('Order quantity must be greater than 0.', 16, 1);
        RETURN;
    END

    IF @tax_rate <= 0
    BEGIN
        RAISERROR('Order tax_rate must be greater than 0.', 16, 1);
        RETURN;
    END

    IF @sell_price < 0
    BEGIN
        RAISERROR('Order sell_price must be greater than or equal to 0.', 16, 1);
        RETURN;
    END

    -- Insert the order details record
    INSERT INTO SALES.ORDERS_DETAILS (order_id, quantity, tax_rate, sell_price, state_id, created_by, created_at, product_id)
    VALUES (@order_id, @quantity, @tax_rate, @sell_price, 'ACTIVO', @created_by, GETDATE(), @product_id);

    set @newId = SCOPE_IDENTITY();
    select @newId as id;
END;
GO


CREATE PROCEDURE SALES.life_cicle_user
    @id INT,
    @state_id VARCHAR(64)
AS
BEGIN
    -- Check if the user exists
    IF NOT EXISTS (SELECT 1 FROM SALES.USERS WHERE id = @id)
    BEGIN
        RAISERROR('User with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    -- Check if the state_id exists
    IF NOT EXISTS (SELECT 1 FROM SALES.STATES WHERE id = @state_id)
    BEGIN
        RAISERROR('State with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    -- Update the user state_id
    UPDATE SALES.USERS
    SET state_id = @state_id
    WHERE id = @id;
END;
GO


CREATE PROCEDURE SALES.life_cicle_shipping_information
    @id INT,
    @state_id VARCHAR(64)
AS
BEGIN
    -- Check if the shipping information exists
    IF NOT EXISTS (SELECT 1 FROM SALES.SHIPPING_INFORMATION WHERE id = @id)
    BEGIN
        RAISERROR('Shipping Information with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    -- Check if the state_id exists
    IF NOT EXISTS (SELECT 1 FROM SALES.STATES WHERE id = @state_id)
    BEGIN
        RAISERROR('State with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    -- Check if the state can only go from 'ACTIVO' to 'ELIMINADO'
    DECLARE @current_state VARCHAR(64);
    SELECT @current_state = state_id  FROM SALES.SHIPPING_INFORMATION WHERE id = @id;

    IF @current_state = 'ACTIVO' AND @state_id = 'ELIMINADO'
    BEGIN
        -- Update the shipping information state_id
        UPDATE SALES.SHIPPING_INFORMATION
        SET state_id = @state_id
        WHERE id = @id;
    END
    ELSE
    BEGIN
        RAISERROR('State can only transition from ACTIVO to ELIMINADO.', 16, 1);
    END
END;
GO

CREATE PROCEDURE SALES.life_cicle_product
    @id INT,
    @state_id VARCHAR(64)
AS
BEGIN
    -- Check if the product exists
    IF NOT EXISTS (SELECT 1 FROM SALES.PRODUCTS WHERE id = @id)
    BEGIN
        RAISERROR('Product with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    -- Check if the state_id exists
    IF NOT EXISTS (SELECT 1 FROM SALES.STATES WHERE id = @state_id)
    BEGIN
        RAISERROR('State with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    -- Update the product state_id
    UPDATE SALES.PRODUCTS
    SET state_id = @state_id
    WHERE id = @id;
END;
GO

CREATE PROCEDURE SALES.life_cicle_product_stock
    @id INT,
    @state_id VARCHAR(64)
AS
BEGIN
    -- Check if the product stock exists
    IF NOT EXISTS (SELECT 1 FROM SALES.PRODUCTS_STOCK WHERE id = @id)
    BEGIN
        RAISERROR('Product stock with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    -- Check if the state_id exists
    IF NOT EXISTS (SELECT 1 FROM SALES.STATES WHERE id = @state_id)
    BEGIN
        RAISERROR('State with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    -- Update the product stock state_id
    UPDATE SALES.PRODUCTS_STOCK
    SET state_id = @state_id
    WHERE id = @id;
END;
GO


CREATE PROCEDURE SALES.life_cicle_category
    @id INT,
    @state_id VARCHAR(64)
AS
BEGIN
    -- Check if the category exists
    IF NOT EXISTS (SELECT 1 FROM SALES.CATEGORIES WHERE id = @id)
    BEGIN
        RAISERROR('Category with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    -- Check if the state_id exists
    IF NOT EXISTS (SELECT 1 FROM SALES.STATES WHERE id = @state_id)
    BEGIN
        RAISERROR('State with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    -- Update the category state_id
    UPDATE SALES.CATEGORIES
    SET state_id = @state_id
    WHERE id = @id;
END;
GO


CREATE PROCEDURE SALES.life_cicle_categories_products
    @product_id INT,
    @category_id INT,
    @state_id VARCHAR(64)
AS
BEGIN
    -- Check if the categories_products entry exists
    IF NOT EXISTS (SELECT 1 FROM SALES.CATEGORIES_PRODUCTS WHERE product_id = @product_id AND category_id = @category_id)
    BEGIN
        RAISERROR('Category-Product combination with the specified IDs does not exist.', 16, 1);
        RETURN;
    END

    -- Check if the state_id exists
    IF NOT EXISTS (SELECT 1 FROM SALES.STATES WHERE id = @state_id)
    BEGIN
        RAISERROR('State with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    -- Update the category-product combination state_id
    UPDATE SALES.CATEGORIES_PRODUCTS
    SET state_id = @state_id
    WHERE product_id = @product_id AND category_id = @category_id;
END;
GO

CREATE PROCEDURE SALES.life_cicle_orders
    @id INT,
    @order_state_id VARCHAR(64)
AS
BEGIN
    -- Check if the order exists
    IF NOT EXISTS (SELECT 1 FROM SALES.ORDERS WHERE id = @id)
    BEGIN
        RAISERROR('Order with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    -- Check if the order_state_id exists
    IF NOT EXISTS (SELECT 1 FROM SALES.ORDERS_STATES WHERE id = @order_state_id)
    BEGIN
        RAISERROR('Order state with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    -- Update the order order_state_id
    UPDATE SALES.ORDERS
    SET order_state_id = @order_state_id
    WHERE id = @id;
END;
GO



CREATE PROCEDURE SALES.life_cicle_update_orders_details
    @id INT,
    @state_id VARCHAR(64)
AS
BEGIN
    -- Check if the order details exists
    IF NOT EXISTS (SELECT 1 FROM SALES.ORDERS_DETAILS WHERE id = @id)
    BEGIN
        RAISERROR('Order details with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    -- Check if the state_id exists
    IF NOT EXISTS (SELECT 1 FROM SALES.STATES WHERE id = @state_id)
    BEGIN
        RAISERROR('State with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    -- Update the order details state_id
    UPDATE SALES.ORDERS_DETAILS
    SET state_id = @state_id
    WHERE id = @id;
END;
GO


CREATE PROCEDURE SALES.update_order_details
    @id INT,  -- ID of the order detail to be updated
    @quantity INT,
    @tax_rate INT,
    @sell_price MONEY
AS
BEGIN
    -- Declare the variables
    DECLARE @role_id INT;
    
    -- Check if the order detail exists
    IF NOT EXISTS (SELECT 1 FROM SALES.ORDERS_DETAILS WHERE id = @id)
    BEGIN
        RAISERROR('Order detail with the specified id does not exist.', 16, 1);
        RETURN;
    END

    
    -- Validate the quantity, tax_rate, and sell_price
    IF @quantity <= 0
    BEGIN
        RAISERROR('Order quantity must be greater than 0.', 16, 1);
        RETURN;
    END

    IF @tax_rate <= 0
    BEGIN
        RAISERROR('Order tax_rate must be greater than 0.', 16, 1);
        RETURN;
    END

    IF @sell_price < 0
    BEGIN
        RAISERROR('Order sell_price must be greater than or equal to 0.', 16, 1);
        RETURN;
    END

    -- Update the order details record
    UPDATE SALES.ORDERS_DETAILS
    SET        
        quantity = @quantity,
        tax_rate = @tax_rate,
        sell_price = @sell_price
    WHERE id = @id;

    
END;


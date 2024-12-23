-- Code convention
-- table names PLURAL_UPPER_CASE_SNAKE_CASE
-- Collumn names lower_case_snake_case
-- Foreign keys: prefixed by FK_ 
-- foreign keys: table names separated by doble _ example:  SHIPPING_INFORMATION__USERS

/*

USE MASTER
DROP database desafio360
*/


create database desafio360
go

use desafio360
GO

create SCHEMA sales
go

create table SALES.STATES (
    id VARCHAR(64) PRIMARY KEY,
    isEnabled bit not null,

    created_by int not null,
    created_at DATETIME not null DEFAULT getdate(),

    CONSTRAINT [ USER STATE name must be greater than 5 characters] CHECK (len(id) > 5)
)

create table SALES.ROLES (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(64),

    state_id varchar(64) not null,
    created_by int not null,
    created_at DATETIME not null DEFAULT getdate(),

    CONSTRAINT [ROLE name must be not null value or greater than 5 characters] CHECK (name is not null and len(name) > 5),
    CONSTRAINT FK_ROLES_STATES FOREIGN KEY (state_id) REFERENCES SALES.STATES(id)

)

create table SALES.USERS (
    id INT identity(1,1) PRIMARY KEY,
    role_id INT,
    state_id varchar(64) NOT NULL,
    email varchar(256) NOT NULL,
    password varchar(64) NOT NULL,
    phone_number varchar(32) NOT NULL,
    date_of_birth DATE NOT null,
    created_by int,
    created_at DATETIME not null DEFAULT getdate(),

    CONSTRAINT FK_ROLES__USERS FOREIGN KEY (role_id) REFERENCES SALES.ROLES(id),
    CONSTRAINT FK_ROLES__STATES FOREIGN KEY (state_id) REFERENCES SALES.STATES(id),
   
)


-- TODO: RENAME TO SHIPPING INFORMATION
create table SALES.SHIPPING_INFORMATION ( 
    id INT PRIMARY KEY IDENTITY(1,1),
    legal_name VARCHAR(128),
    trade_name VARCHAR(128),
    shipping_address varchar(64),
    phone_number varchar(32),
    email varchar(256),
    user_id int not null,
    
    state_id varchar(64) not null,
    created_by int not null,
    created_at DATETIME not null DEFAULT getdate(),

    CONSTRAINT [SHIPPING_INFORMATION legal_name or trade_name must be not null] CHECK (legal_name is not null or trade_name is not null),
    CONSTRAINT FK_SHIPPING_INFORMATION__USERS___user_id FOREIGN KEY (user_id) REFERENCES SALES.USERS(id),    
    CONSTRAINT FK_SHIPPING_INFORMATION__USERS___created_by FOREIGN KEY (created_by) REFERENCES SALES.USERS(id),    
    CONSTRAINT FK_SHIPPING_INFORMATION__STATES FOREIGN KEY (state_id) REFERENCES SALES.STATES(id),
)




create table SALES.PRODUCTS (
    id INT identity(1,1) PRIMARY KEY,
    name VARCHAR(64) not null,
    brand varchar(64) not null,
    code VARCHAR(64) not null,
    photo varbinary(max),
    
    state_id varchar(64) NOT NULL,
    created_by int,
    created_at DATETIME not null DEFAULT getdate(),

    CONSTRAINT [PRODUCT name must be not null ] CHECK (name is not null),
    CONSTRAINT FK_PODUCTS__USERS FOREIGN KEY (created_by) REFERENCES SALES.USERS(id),
    CONSTRAINT FK_PRODUCTS__STATES FOREIGN KEY (state_id) REFERENCES SALES.STATES(id),  
    
)



create table SALES.PRODUCTS_STOCK (
    id int IDENTITY(1,1) PRIMARY KEY,
    product_id int not null,
    purchase_price money not null,

    state_id varchar(64) not null,
    created_by int,
    created_at DATETIME not null DEFAULT getdate(),
    
    CONSTRAINT FK_PRODUCTS_STOCK__STATES FOREIGN KEY (state_id) REFERENCES SALES.STATES(id),
    CONSTRAINT FK_PRODUCTS_STOCK__PRODUCTS FOREIGN KEY (product_id) REFERENCES SALES.PRODUCTS(id),
    CONSTRAINT FK_PODUCTS_STOCK__USERS FOREIGN KEY (created_by) REFERENCES SALES.USERS(id)  
)

create table SALES.CATEGORIES (
    id int IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(32) not null,
    
    state_id varchar(64) NOT NULL,
    created_by int not null,
    created_at DATETIME not null DEFAULT getdate(),

    CONSTRAINT [CATETORY name must be not null ] CHECK (name is not null),
    CONSTRAINT FK_CATETORIES__STATES FOREIGN KEY (state_id) REFERENCES SALES.STATES(id),
    CONSTRAINT FK_CATETORIES__USERS FOREIGN KEY (created_by) REFERENCES SALES.USERS(id),
)


create table SALES.CATEGORIES_PRODUCTS (
    product_id int not null,
    category_id int not null,

    state_id varchar(64) NOT NULL,
    created_by int,
    created_at DATETIME not null DEFAULT getdate(),

    CONSTRAINT FK_CATEGORIES_PRODUCTS__STATES FOREIGN KEY (state_id) REFERENCES SALES.STATES(id),
    CONSTRAINT FK_CATEGORIES_PRODUCTS__USERS FOREIGN KEY (created_by) REFERENCES SALES.USERS(id),
    CONSTRAINT PK_CATEGORIES_PRODUCTS  PRIMARY KEY (category_id, product_id)
)



create table SALES.ORDERS_STATES (
    id VARCHAR(64) PRIMARY KEY,

    state_id varchar(64) NOT NULL,
    created_by int not null,
    created_at DATETIME not null DEFAULT getdate(),

    CONSTRAINT [ USER STATE name must be not null value or greater than 5 characters] CHECK (len(id) > 5),
    CONSTRAINT FK_ORDERS_STATES__STATES FOREIGN KEY (state_id) REFERENCES SALES.STATES(id),
    CONSTRAINT FK_ORDERS_STATES__USERS FOREIGN KEY (created_by) REFERENCES SALES.USERS(id)
);

create table SALES.ORDERS (
    id INT IDENTITY(1,1) PRIMARY KEY,
    client_id int not NULL,
    estimated_delivery_date datetime not null,
    delivery_date datetime,

    order_state_id varchar(64) NOT NULL,
    created_by int,    
    created_at datetime DEFAULT getdate(),


    CONSTRAINT FK_ORDERS__STATES FOREIGN KEY (order_state_id) REFERENCES SALES.ORDERS_STATES(id),
    CONSTRAINT FK_ORDERS__USERS FOREIGN KEY (created_by) REFERENCES SALES.USERS(id),
    CONSTRAINT FK_ORDERS__SHIPPING_INFORMATION FOREIGN KEY (client_id) REFERENCES SALES.SHIPPING_INFORMATION(id),

)

create table SALES.ORDERS_DETAILS (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id int not null,
    quantity int not null,
    tax_rate int not null,
    sell_price money not null,

    state_id varchar(64) NOT NULL,
    created_by int,    
    created_at datetime DEFAULT getdate(),
    
    CONSTRAINT [ORDER quantity must be greater than 0] check(quantity > 0),
    CONSTRAINT [ORDER tax_rate must be greater than 0] check(tax_rate > 0),
    CONSTRAINT [ORDER price must be greater or equal to 0] check(sell_price >= 0),

    CONSTRAINT FK_ORDERS_DETAILS__STATES FOREIGN KEY (state_id) REFERENCES SALES.STATES(id),
    CONSTRAINT FK_ORDERS_DETAILS__USERS FOREIGN KEY (created_by) REFERENCES SALES.USERS(id),
)

GO

alter table SALES.ORDERS_DETAILS add product_id int not null;
GO
alter table SALES.ORDERS_DETAILS add CONSTRAINT FK_ORDERS_DETAILS__PRODUCTS FOREIGN KEY (product_id) REFERENCES SALES.PRODUCTS(id)

GO

INSERT INTO sales.STATES (id,isEnabled,created_by,created_at) 
VALUES
	 (N'ACTIVO',1,1,'2024-12-22 04:31:50.813'),
	 (N'ELIMINADO',1,1,'2024-12-22 17:08:13.437');

GO

INSERT INTO sales.ROLES (name,state_id,created_by,created_at) 
VALUES
	 (N'OPERATOR',N'ACTIVO',1,'2024-12-22 04:32:10.987'),
	 (N'CLIENT',N'ACTIVO',1,'2024-12-22 04:32:10.987');

GO

INSERT INTO sales.USERS 
(role_id,state_id,email,password,phone_number,date_of_birth,created_by,created_at) 
VALUES (1,N'ACTIVO',N'test@test.com',N'$2y$12$6/qjQHZliu.8zeurMjd4G./rDvRYPBqpJ2EXrAsrsfwVCoiwdmg4q',N'11111','1980-10-10',4,'2024-12-22 04:35:09.063');
GO


INSERT INTO sales.ORDERS_STATES (id,state_id,created_by,created_at) VALUES
	 (N'AWAITING_PAYMENT',N'ACTIVO',1,'2024-12-23 00:17:58.613'),
	 (N'CANCELLED',N'ACTIVO',1,'2024-12-23 00:17:58.59'),
	 (N'COMPLETED',N'ACTIVO',1,'2024-12-23 00:17:58.587'),
	 (N'DELIVERED',N'ACTIVO',1,'2024-12-23 00:17:58.583'),
	 (N'FAILED',N'ACTIVO',1,'2024-12-23 00:17:58.603'),
	 (N'ON_HOLD',N'ACTIVO',1,'2024-12-23 00:17:58.61'),
	 (N'OUT_FOR_DELIVERY',N'ACTIVO',1,'2024-12-23 00:17:58.577'),
	 (N'PAYMENT_CONFIRMED',N'ACTIVO',1,'2024-12-23 00:17:58.617'),
	 (N'PENDING',N'ACTIVO',1,'2024-12-23 00:17:58.563'),
	 (N'PLACED',N'ACTIVO',1,'2024-12-23 00:17:58.56');
INSERT INTO sales.ORDERS_STATES (id,state_id,created_by,created_at) VALUES
	 (N'PROCESSING',N'ACTIVO', 1,'2024-12-23 00:17:58.57'),
	 (N'REFUNDED',N'ACTIVO',1,'2024-12-23 00:17:58.597'),
	 (N'RETURNED',N'ACTIVO',1,'2024-12-23 00:17:58.6'),
	 (N'SHIPPED',N'ACTIVO',1,'2024-12-23 00:17:58.573');
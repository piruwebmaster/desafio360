CREATE VIEW sales.VW_PRODUCTS 
AS SELECT id, name, brand, code, photo, state_id FROM sales.PRODUCTS;
GO

CREATE VIEW SALES.VW_CATEGORIES
AS SELECT id, name, state_id from sales.CATEGORIES;
GO

CREATE VIEW SALES.VW_USERS
AS SELECT id, EMAIL, PHONE_NUMBER, DATE_OF_BIRTH, STATE_ID, ROLE_ID from sales.USERS;
GO

CREATE VIEW SALES.VW_CLIENTS
AS SELECT id, legal_name, trade_name, shipping_address, phone_number, email, user_id, state_id from sales.SHIPPING_INFORMATION ;
GO

create view SALES.VW_ORDERS as
SELECT id, client_id, estimated_delivery_date, delivery_date, order_state_id FROM sales.ORDERS
GO

CREATE VIEW sales.VW_ORDER_DETAILS
AS 
SELECT id, order_id, quantity, tax_rate, sell_price, state_id, product_id
FROM desafio360.sales.ORDERS_DETAILS;

CREATE VIEW SALES.VW_LOGIN
    AS SELECT id, email, password from sales.USERS u
    where u.state_id = 'ACTIVO' ;
GO


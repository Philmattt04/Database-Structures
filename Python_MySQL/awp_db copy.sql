CREATE SCHEMA AmazonWebPage;

use AmazonWebPage;

/*
This database has 4 tables: Customer, Product, ShoppingCart, and Item. The relationships of this database are that 
each customer can have multiple shopping carts, each shopping cart can contain multiple items, and each item corresponds to one product.
The funcitonality of this database is customers can be identified by their unique customer_id, products can be identified by their unique,
product_id and customers can have mulitple shopping carts to add items to. Items in the shopping cart are associated with both the product
and the cart that they belong to. The quantity of each item in the shopping cart can be adjusted. The total price of items in a shopping cart
can be calucalted. Various queries can be performed to retrieve information about customers, products, shopping carts, and items, and to perform
updates as necessary
*/

-- Creates table called Customer that stores information about customers. 
-- Contains 4 attributes: customer_id, name, email, address
CREATE TABLE Customer 
(
	customer_id INT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    address VARCHAR(255)
);

-- Creates table called Product that stores information about products available in the store.  
-- Contains 4 attributes: product_id, name, price, and description
CREATE TABLE Product
(
	product_id INT PRIMARY KEY,
    name VARCHAR(255),
    price DECIMAL(10,2),
    description TEXT
);

-- Creates table called ShoppingCart which stores information about products that are available in the database
-- Contains 3 attributes: cart_id, customer_id, creation_date 
CREATE TABLE ShoppingCart
(
	cart_id INT PRIMARY KEY,
    customer_id INT,
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Creates table called Item which stores information about items in shopping carts
-- Contains 4 attributes: item_id, product_id, cart_id, quantity
CREATE TABLE Item
(
	item_id INT PRIMARY KEY,
    product_id INT,
    cart_id INT,
    quantity INT,
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (cart_id) REFERENCES ShoppingCart(cart_id)
);

-- Adds two new records to the Customer table, each representing a different customer
INSERT INTO Customer (customer_id, name, email, address)
VALUES
	(1, 'Jerry Curl', 'jerrycurls123@gmail.com', '123 Main St'),
    (2, 'Coopants Mudson', 'coopmuddy345@gmail.com', '345 Woody Dr');
    
-- Adds two new records to the Product table, each representing a diffrerent product    
INSERT INTO Product (product_id, name, price, description)
VALUES
	(101, 'Game Console', 499.99, 'Playstaion 5'),
	(102, 'Desktop', 1199.99, 'Master Gaming PC');

-- Adds two new records to the ShoppingCart table, each representing a shopping cart with a different customer
INSERT INTO ShoppingCart (cart_id, customer_id)
VALUES
	(201, 1),
    (202, 2);
    
-- Adds two new records to the Item table, each representing an item in a shopping cart    
INSERT INTO Item (item_id, product_id, cart_id, quantity)
VALUES
	(301, 101, 201, 1),
    (302, 102, 202, 2);

-- Selects a column from the Customer table that contains the email jerrycurls123@gmail.com
SELECT * FROM Customer WHERE email = 'jerrycurls123@gmail.com';

-- Selects a column from the Product table that contains the price of a product that is greater than 1000
SELECT * FROM Product WHERE price > 1000;

-- Retrieves information about customers and the products in their shopping carts
-- Uses JOIN operations between multiple tables
SELECT c.name AS customer_name, p.name AS product_name
FROM ShoppingCart sc
JOIN Customer c ON sc.customer_id = c.customer_id
JOIN Item i ON sc.cart_id = i.cart_id
JOIN Product p ON i.product_id = p.product_id;

-- Retriecs the name price and quantity of products in a specific shopping cart 
SELECT p.name AS product_name, p.price, i.quantity
FROM Item i
JOIN Product p ON i.product_id = p.product_id
WHERE i.cart_id = 202;

-- Updates customer address to 456 Elm St to the customer with ID #2
UPDATE Customer SET address = '456 Elm St' WHERE customer_id = 2;

-- Updates the item quantity to 3 for the item with ID #302
UPDATE Item SET quantity = 3 WHERE item_id = 302;

-- Calculates the total price for items in shopping cart ID #202
SELECT SUM(p.price * i.quantity) AS total_price
FROM Item i
JOIN Product p ON i.product_id = p.product_id
WHERE i.cart_id = 202;

-- Counts the number of items in each shopping cart    
SELECT cart_id, COUNT(*) AS num_items
FROM Item
GROUP BY cart_id;

-- Selects the customer name for customers with items in shopping cart ID #202
SELECT name
FROM Customer
WHERE customer_id IN (SELECT customer_id FROM ShoppingCart WHERE cart_id = 202);

-- Selects the product name and price for products in shopping cart ID #201
SELECT name, price
FROM Product
WHERE product_id IN (SELECT product_id FROM Item WHERE cart_id = 201);

-- Checks if there are any items in shopping cart ID #203
SELECT CASE WHEN EXISTS (SELECT * FROM Item WHERE cart_id = 203) THEN 'Yes' ELSE 'No' END AS items_exist;

-- Checks the status of shopping carts and customers
SELECT CASE WHEN NOT EXISTS (SELECT * FROM ShoppingCart) THEN 'No customers' 
            WHEN EXISTS (SELECT * FROM Customer WHERE customer_id NOT IN (SELECT customer_id FROM ShoppingCart)) THEN 'Customers without items'
            ELSE 'All customers have items' END AS status;

-- Selects the customer name, email, and number of items in the shopping cart
WITH CartItems AS (
    SELECT customer_id, COUNT(*) AS num_items
    FROM ShoppingCart sc
    JOIN Item i ON sc.cart_id = i.cart_id
    GROUP BY customer_id
)
SELECT c.name, c.email, ci.num_items
FROM Customer c
JOIN CartItems ci ON c.customer_id = ci.customer_id;

-- Selects the customer information along with the shopping cart details
WITH CustomerCarts AS (
    SELECT c.*, sc.cart_id, sc.creation_date
    FROM Customer c
    LEFT JOIN ShoppingCart sc ON c.customer_id = sc.customer_id
)
SELECT * FROM CustomerCarts;

-- 2 commands that  that change the value(s) of some attributes using some conditions
UPDATE Customer
SET address = '456 Elm St'
WHERE customer_id = 2;

UPDATE Item
SET quantity = quantity + 1
WHERE item_id = 302;

/*
 5 Commands that I feel are important/necessary for this database because they facilitate data retrieval, 
updates, and analysis, which are essential for maintaining and utilizing the database effectively
in various scenarios such as e-commerce, inventory management, and customer relationship management.
 */
SELECT * FROM Customer WHERE email = 'jerrycurls123@gmail.com';

SELECT * FROM Product WHERE price > 1000;

UPDATE Customer SET address = '456 Elm St' WHERE customer_id = 2;

UPDATE Item SET quantity = quantity + 1 WHERE item_id = 302;

SELECT SUM(p.price * i.quantity) AS total_price
FROM Item i
JOIN Product p ON i.product_id = p.product_id
WHERE i.cart_id = 202;


-- Defines a procedure that calculates the price of all the products in the Product table
DELIMITER //
CREATE PROCEDURE GetAveragePrice()
BEGIN
	SELECT AVG(price) AS average_price FROM Product;
END //
DELIMITER ;
 
-- Defines a fucntion that retrieves the name of a customer based on the customer_id 
DELIMITER //
CREATE FUNCTION GetCustomerName(customer_id INT) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
    DECLARE customer_name VARCHAR(255);
    SELECT name INTO customer_name FROM Customer WHERE customer_id = customer_id LIMIT 1;
    RETURN customer_name;
END //
DELIMITER ;


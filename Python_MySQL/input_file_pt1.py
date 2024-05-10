import datetime
import mysql.connector

cnx = mysql.connector.connect(user='root', password='******', host='localhost', database='AmazonWebPage')
cursor = cnx.cursor()

try:
    # Query 1: Retrieve customer information by email
    email = 'jerrycurls123@gmail.com'
    query = "SELECT * FROM Customer WHERE email = %s"
    cursor.execute(query, (email,))
    print("Query 1 Results:")
    for data in cursor:
        print(data)

    # Query 2: Retrieve items in a specific shopping cart
    cart_id = 202
    query = "SELECT * FROM Item WHERE cart_id = %s"
    cursor.execute(query, (cart_id,))
    print("\n Query 2 Results:")
    for data in cursor:
        print(data)

    # Query 3: Retrieve customer and product names for items in shopping carts
    query = """
    SELECT c.name AS customer_name, p.name AS product_name
    FROM ShoppingCart sc
    JOIN Customer c ON sc.customer_id = c.customer_id
    JOIN Item i ON sc.cart_id = i.cart_id
    JOIN Product p ON i.product_id = p.product_id
    """
    cursor.execute(query)
    print("\n Query 3 Results:")
    for data in cursor:
        print(data)

    # Query 4: Retrive product name, price, and quantity for a specific shopping cart
    cart_id = 202
    query = """
    SELECT p.name AS product_name, p.price, i.quantity
    FROM Item i
    JOIN Product p ON i.product_id = p.product_id
    WHERE i.cart_id = %s
    """
    cursor.execute(query, (cart_id,))
    print("\n Query 4 Results:")
    for data in cursor:
        print(data)

    # Query 5: Update customer address by customer ID
    new_address = '456 Elm St'
    customer_id = 2
    query = "UPDATE Customer SET address = %s WHERE customer_id = %s"
    cursor.execute(query, (new_address, customer_id))
    cnx.commit()
    print(f"\n Query 5: Address updated for customer ID {customer_id}")

    # Query 6: Update item quantity by item ID
    new_quantity = 3
    item_id = 302
    query = "UPDATE Item SET quantity = %s WHERE item_id = %s"
    cursor.execute(query, (new_quantity, item_id))
    cnx.commit()
    print(f"\n Query 6: Quantity updated for item ID {item_id}")

except mysql.connector.Error as err:
    print("Error", err)

cursor.close()
cnx.close()

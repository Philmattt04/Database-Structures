cnx = mysql.connector.connect(user='root', password='******', host='localhost', database='AmazonWebPage')
cursor = cnx.cursor()

try:
    # Call the procedure GetAveragePrice
    cursor.callproc('GetAveragePrice')
    for result in cursor.stored_results():
        avg_price = result.fetchone()[0]
        print("Average Price of Products:", avg_price)

except mysql.connector.Error as err:
    print("Error:", err)

try:
    # Calls the function GetCustomerName
    cursor.execute("SELECT GetCustomerName(1) AS customer_name")
    customer_name = cursor.fetchone()[0]
    print("Customer Name:", customer_name)
except mysql.connector.Error as err:
    print("Error:", err)

cursor.close()
cnx.close()

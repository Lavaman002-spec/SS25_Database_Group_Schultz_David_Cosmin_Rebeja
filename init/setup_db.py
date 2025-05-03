import mariadb
import sys
from tabulate import tabulate

try:
    conn = mariadb.connect(
        user="root",
        password="rootpass",
        host="db",
        port=3306
    )
    cursor = conn.cursor()
    print("Connected to MariaDB server")

    cursor.execute("CREATE DATABASE IF NOT EXISTS ski_vacation_db;")
    cursor.execute("USE ski_vacation_db;")

    print("Executing schema.sql...")
    with open("schema.sql", "r") as f:
        schema_sql = f.read()
        for stmt in schema_sql.split(';'):
            stmt = stmt.strip()
            if stmt:
                try:
                    cursor.execute(stmt)
                except mariadb.Error as e:
                    print(f"Schema error: {e}")

    # Step 3: Execute sample_data.sql
    print("Executing sample_data.sql...")
    with open("sample_data.sql", "r") as f:
        data_sql = f.read()
        for stmt in data_sql.split(';'):
            stmt = stmt.strip()
            if stmt:
                try:
                    cursor.execute(stmt)
                except mariadb.Error as e:
                    print(f"Data insert error: {e}")

    print("Database setup completed successfully\n")

    # Step 4: Run queries
    queries = {
        "Customers with future skipass bookings sorted by reservation duration": """
            SELECT C.Name, SUM(DATEDIFF(R.End_Date, R.Start_Date)) AS total_nights
            FROM Customer C
            JOIN Reservation R ON C.Customer_ID = R.Customer_ID
            JOIN SkiPass S ON R.Reservation_ID = S.Reservation_ID
            WHERE R.Start_Date > CURRENT_DATE()
            GROUP BY C.Customer_ID
            ORDER BY total_nights DESC;
        """,
        "Most booked package": """
            SELECT VP.Name, COUNT(*) AS bookings
            FROM Vacation_Package VP
            JOIN Reservation R ON VP.Package_ID = R.Package_ID
            GROUP BY VP.Package_ID
            ORDER BY bookings DESC
            LIMIT 1;
        """,
        "Reservations above price threshold (1000 EUR)": """
            SELECT R.Reservation_ID, C.Name, VP.Price
            FROM Reservation R
            JOIN Customer C ON R.Customer_ID = C.Customer_ID
            JOIN Vacation_Package VP ON R.Package_ID = VP.Package_ID
            WHERE VP.Price > 1000;
        """,
        "Total revenue from package sales in 2025": """
            SELECT SUM(VP.Price) AS revenue_2025
            FROM Reservation R
            JOIN Vacation_Package VP ON R.Package_ID = VP.Package_ID
            WHERE R.Booking_Date BETWEEN '2025-01-01' AND '2025-12-31';
        """,
        "Number of skipasses per resort": """
            SELECT Res.Name AS Resort, COUNT(*) AS Skipasses
            FROM Grant_Access GA
            JOIN Resort Res ON GA.Resort_ID = Res.Resort_ID
            GROUP BY GA.Resort_ID
            ORDER BY Skipasses DESC;
        """,
        "Top 3 customers by number of reservations": """
            SELECT C.Name, COUNT(*) AS Reservations
            FROM Customer C
            JOIN Reservation R ON C.Customer_ID = R.Customer_ID
            GROUP BY C.Customer_ID
            ORDER BY Reservations DESC
            LIMIT 3;
        """
    }

    for title, sql in queries.items():
        print(f"# {title}")
        cursor.execute(sql)
        rows = cursor.fetchall()
        if rows:
            print(tabulate(rows, headers=[desc[0] for desc in cursor.description], tablefmt="psql"))
        else:
            print("No results found.")
        print()

except mariadb.Error as e:
    print(f"Error connecting to MariaDB: {e}")
    sys.exit(1)

finally:
    if conn:
        conn.close()
        print("Connection closed")
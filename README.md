![ER diagram](https://github.com/user-attachments/assets/9b818600-449b-4f16-93c5-75cd61ec1ddd)

[Ski_Vacation_ER_Design_Justification.pdf](https://github.com/user-attachments/files/19655796/Ski_Vacation_ER_Design_Justification.pdf)

# SS25 Database Project – Ski Vacation System

## 👨‍💼 Authors

David Schultz & Cosmin Rebeja

## 📆 Project Overview

This project sets up a MariaDB-based database system for managing ski vacation reservations. It automates database creation, schema setup, and data seeding using Docker Compose. A Python script runs several business queries and prints the results to the console.

---

## ✨ Features

- MariaDB database setup using Docker
- Automated schema and data population
- Query driver that runs 6 business-related SQL queries
- All results are printed using `tabulate` for clean formatting

---

## 🚀 How to Run the Project

### 1. Clone the Repository

Using HTTPS:

```bash
git clone https://github.com/Lavaman002-spec/SS25_Database_Group_Schultz_David_Cosmin_Rebeja.git
```

Using SSH:

```bash
git clone <git@github.com:Lavaman002-spec/SS25_Database_Group_Schultz_David_Cosmin_Rebeja.git>
cd SS25_Database_Group_Schultz_David_Cosmin_Rebeja
```

### 2. Build and Run with Docker Compose

```bash
docker compose up --build
```

This will:

- Start the MariaDB container (`vacation-db`)
- Wait until it's healthy
- Run the `init-db` container that:

  - Executes `schema.sql` and `sample_data.sql`
  - Runs SQL queries and prints results to the terminal

---

## 🔧 Services Overview

### MariaDB (`vacation-db`)

- Port: `3306`
- User: `root`
- Password: `rootpass`
- Database: `ski_vacation_db`

### Init-DB (Python Script)

- Sets up tables and inserts data
- Runs 6 business queries:

  1. Customers with future skipass bookings sorted by reservation duration
  2. Most booked package
  3. Reservations above price threshold (1000 EUR)
  4. Total revenue from package sales in 2025
  5. Number of skipasses per resort
  6. Top 3 customers by number of reservations

---

## 🔍 Query Output Example

```
# Most booked package
+----------------+-----------+
| Name           | bookings  |
+----------------+-----------+
| Snow Deluxe    | 5         |
+----------------+-----------+
```

If "No results found." appears, it means sample data doesn’t match the query criteria (e.g., no future dates).

---

## 🔧 How to Stop and Clean Up

```bash
docker compose down --volumes
```

This will stop and remove all containers and delete the database volume.

---

## 📁 Project Structure

```
.
├── docker-compose.yml
└── init/
    ├── Dockerfile
    ├── init_and_query.py
    ├── schema.sql
    └── sample_data.sql
```

---

## 📄 Notes

- Ensure Docker Desktop is running before starting
- All query results are printed directly to your terminal
- `tabulate` is used for pretty-printing query outputs

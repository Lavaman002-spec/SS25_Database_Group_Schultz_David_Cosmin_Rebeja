import psycopg2
from datetime import datetime, timedelta
import random
import time

# --- Database Connection Details ---
DB_HOST = "localhost"
DB_NAME = "ski_vacation_pg_db"
DB_USER = "postgres"
DB_PASSWORD = "pass1234" 

# --- Simulation Parameters ---
NUM_SKIPASSES = 20  
NUM_RESORTS = 10    
SCAN_INTERVAL_SECONDS = 0.1 
TOTAL_SCANS_TO_SIMULATE = 1000 

def get_db_connection():
    """Establishes and returns a database connection."""
    conn = None
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD
        )
        print("Successfully connected to the database.")
        return conn
    except psycopg2.Error as e:
        print(f"Error connecting to the database: {e}")
        return None

def simulate_skipass_scans():
    """Simulates skipass scanning data and inserts it into the hypertable."""
    conn = get_db_connection()
    if not conn:
        print("Failed to get database connection. Exiting simulator.")
        return

    try:
        cur = conn.cursor()
        print(f"Starting skipass scan simulation for {TOTAL_SCANS_TO_SIMULATE} scans...")

        # Initialize current time to now
        current_time = datetime.now()

        for i in range(TOTAL_SCANS_TO_SIMULATE):
            skipass_id = random.randint(1, NUM_SKIPASSES)
            resort_id = random.randint(1, NUM_RESORTS)

            insert_sql = """
            INSERT INTO skipass_scans (time, skipass_id, resort_id)
            VALUES (%s, %s, %s);
            """
            cur.execute(insert_sql, (current_time, skipass_id, resort_id))

            if (i + 1) % 100 == 0: 
                conn.commit()
                print(f"Committed {i + 1} scans.")

            # Advance time for the next scan
            current_time += timedelta(seconds=random.uniform(0.1, 5.0)) 

            time.sleep(SCAN_INTERVAL_SECONDS)

        conn.commit()
        print(f"Simulation complete. Total {TOTAL_SCANS_TO_SIMULATE} scans inserted.")

    except psycopg2.Error as e:
        print(f"Error during simulation: {e}")
        conn.rollback() 
    finally:
        if conn:
            cur.close()
            conn.close()
            print("Database connection closed.")

if __name__ == "__main__":
    simulate_skipass_scans()

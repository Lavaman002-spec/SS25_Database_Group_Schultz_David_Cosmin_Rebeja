import psycopg2
from datetime import datetime, timedelta
import time

# --- Database Connection Details ---
DB_HOST = "localhost"
DB_NAME = "ski_vacation_pg_db"
DB_USER = "postgres"
DB_PASSWORD = "pass1234" 

# --- Continuous Aggregate Details ---
CONTINUOUS_AGGREGATE_NAME = "hourly_resort_scans"
TIME_BUCKET_INTERVAL = "1 hour"

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

def create_continuous_aggregate(conn):

    original_autocommit_status = conn.autocommit
    conn.autocommit = True

    cur = conn.cursor()
    try:
        cur.execute(f"DROP MATERIALIZED VIEW IF EXISTS {CONTINUOUS_AGGREGATE_NAME} CASCADE;")
        print(f"Dropped existing continuous aggregate view '{CONTINUOUS_AGGREGATE_NAME}' (if any).")

        create_view_sql = f"""
        CREATE MATERIALIZED VIEW {CONTINUOUS_AGGREGATE_NAME}
        WITH (timescaledb.continuous) AS
        SELECT
            time_bucket('{TIME_BUCKET_INTERVAL}', time) AS bucket,
            resort_id,
            COUNT(*) AS total_scans,
            COUNT(DISTINCT skipass_id) AS unique_skipasses_scanned
        FROM skipass_scans
        GROUP BY bucket, resort_id
        ORDER BY bucket DESC, resort_id ASC;
        """
        cur.execute(create_view_sql)
        print(f"Continuous aggregate view '{CONTINUOUS_AGGREGATE_NAME}' created successfully.")

        cur.execute(f"""
            SELECT add_continuous_aggregate_policy(
                '{CONTINUOUS_AGGREGATE_NAME}',
                start_offset => INTERVAL '1 day',
                end_offset => INTERVAL '1 minute',
                schedule_interval => INTERVAL '5 minutes'
            );
        """)
        print(f"Continuous aggregate policy added for '{CONTINUOUS_AGGREGATE_NAME}'.")

    except psycopg2.Error as e:
        print(f"Error creating continuous aggregate: {e}")
        pass 
    finally:
        cur.close()
        conn.autocommit = original_autocommit_status


def query_continuous_aggregate(conn):
    """Queries the continuous aggregate and prints the summary."""
    cur = conn.cursor()
    try:
        print(f"\n--- Querying Continuous Aggregate: {CONTINUOUS_AGGREGATE_NAME} ---")
        query_sql = f"""
        SELECT
            bucket,
            resort_id,
            total_scans,
            unique_skipasses_scanned
        FROM {CONTINUOUS_AGGREGATE_NAME}
        ORDER BY bucket DESC, resort_id ASC
        LIMIT 20; -- Limit to show recent data
        """
        cur.execute(query_sql)
        results = cur.fetchall()

        if results:
            print("Summary of Scans (Time Bucket, Resort ID, Total Scans, Unique Skipasses):")
            for row in results:
                formatted_bucket = row[0].strftime('%Y-%m-%d %H:00')
                print(f"  {formatted_bucket} | Resort {row[1]} | Scans: {row[2]} | Unique Skipasses: {row[3]}")
        else:
            print("No data found in the continuous aggregate yet. It might need a refresh.")

    except psycopg2.Error as e:
        print(f"Error querying continuous aggregate: {e}")
    finally:
        cur.close()

def refresh_continuous_aggregate(conn):
    """Manually refreshes the continuous aggregate."""
    original_autocommit_status = conn.autocommit
    conn.autocommit = True

    cur = conn.cursor()
    try:
        print(f"\n--- Manually Refreshing Continuous Aggregate: {CONTINUOUS_AGGREGATE_NAME} ---")
        cur.execute(f"CALL refresh_continuous_aggregate('{CONTINUOUS_AGGREGATE_NAME}', NULL, NOW());")
        print(f"Continuous aggregate '{CONTINUOUS_AGGREGATE_NAME}' manually refreshed.")
    except psycopg2.Error as e:
        print(f"Error refreshing continuous aggregate: {e}")
        pass 
    finally:
        cur.close()
        conn.autocommit = original_autocommit_status

if __name__ == "__main__":
    conn = get_db_connection()
    if conn:
        try:
            create_continuous_aggregate(conn)

            print("\nWaiting a few seconds for initial aggregate processing...")
            time.sleep(5)


            query_continuous_aggregate(conn)


        finally:
            if conn:
                conn.close()
                print("Database connection closed.")

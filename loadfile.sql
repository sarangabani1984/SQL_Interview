
import pyodbc
import pandas as pd

# Connection details
server = r"JNPR-WIN-8G726J\SQLEXPRESS"
database = "PL_300"
table = "dbo.Sales"   # Use dbo.Sales unless your schema is different

# Build connection (Windows Authentication)
conn_str = (
    "DRIVER={ODBC Driver 17 for SQL Server};"
    f"SERVER={server};"
    f"DATABASE={database};"
    "Trusted_Connection=Yes;"
)

# Connect and read
with pyodbc.connect(conn_str) as conn:
    query = f"SELECT * FROM {table};"
    df = pd.read_sql(query, conn)

print(df.head())
print(f"\nRows: {len(df):,} | Columns: {len(df.columns)}")

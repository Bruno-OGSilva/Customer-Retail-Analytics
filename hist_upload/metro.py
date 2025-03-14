import os
import pandas as pd
from google.cloud import bigquery
from google.oauth2 import service_account


def load_csv_files(directory: str) -> pd.DataFrame:
    """Loads all CSV files from a directory, extracts relevant data, and concatenates into a DataFrame."""
    all_files = [
        os.path.join(directory, f) for f in os.listdir(directory) if f.endswith(".csv")
    ]

    if not all_files:
        raise ValueError("No CSV files found in the specified directory.")

    df_list = []

    for file in all_files:
        df = pd.read_csv(
            file,
            skiprows=lambda x: x < 1,
            names=[
                "Week End Date",
                "Store No",
                "Product",
                "Dollar Sales",
                "Unit Sales",
                "UPC ID",
                "Geography",
            ],
            dtype={
                "Week End Date": str,
                "Store No": str,
                "Product": str,
                "Dollar Sales": str,
                "Unit Sales": str,
                "UPC ID": str,
                "Geography": str,
            },
            encoding="utf-8",
            low_memory=False,
        )
        df.dropna(
            subset=["Store No", "Product", "UPC ID"], inplace=True
        )  # Remove empty rows
        df["Dollar Sales"] = (
            df["Dollar Sales"].astype(str).fillna("")
        )  # Ensure all values are strings
        df["Unit Sales"] = (
            df["Unit Sales"].astype(str).fillna("")
        )  # Ensure all values are strings

        # Create unique_id by concatenating sobeys, UPC No, store_id, and Time with | separator
        df["unique_id"] = (
            "metro|" + df["UPC ID"] + "|" + df["Store No"] + "|" + df["Week End Date"]
        )

        # Add current timestamp to timestamp column
        df["timestamp"] = pd.to_datetime("now")

        # Add the retail group
        df["retail_group"] = "Metro"

        # Drop rows where both Dollar Sales and Unit Sales are "0"
        df = df[~((df["Dollar Sales"] == "0") & (df["Unit Sales"] == "0"))]

        df_list.append(df)

    unified_df = pd.concat(df_list, ignore_index=True)
    return unified_df


def create_table_if_not_exists(client, dataset_id: str, table_id: str):
    """Creates a BigQuery table if it does not exist."""
    dataset_ref = client.dataset(dataset_id)
    table_ref = dataset_ref.table(table_id)

    schema = [
        bigquery.SchemaField("Week End Date", "STRING"),
        bigquery.SchemaField("Store No", "STRING"),
        bigquery.SchemaField("Product", "STRING"),
        bigquery.SchemaField("Dollar Sales", "STRING"),
        bigquery.SchemaField("Unit Sales", "STRING"),
        bigquery.SchemaField("UPC ID", "STRING"),
        bigquery.SchemaField("Geography", "STRING"),
        bigquery.SchemaField("unique_id", "STRING"),
        bigquery.SchemaField("timestamp", "TIMESTAMP"),
        bigquery.SchemaField("retail_group", "STRING"),
    ]

    try:
        client.get_table(table_ref)  # Check if the table exists
        print(f"Table {table_id} already exists.")
    except Exception:
        table = bigquery.Table(table_ref, schema=schema)
        client.create_table(table)
        print(f"Created table {table_id}.")


def upload_to_bigquery(
    df: pd.DataFrame,
    credentials_path: str,
    project_id: str,
    dataset_id: str,
    table_id: str,
):
    """Uploads a DataFrame to a BigQuery table using service account credentials."""
    credentials = service_account.Credentials.from_service_account_file(
        credentials_path
    )
    client = bigquery.Client(credentials=credentials, project=project_id)

    create_table_if_not_exists(
        client, dataset_id, table_id
    )  # Ensure table exists before uploading

    table_ref = f"{project_id}.{dataset_id}.{table_id}"
    job_config = bigquery.LoadJobConfig(
        write_disposition=bigquery.WriteDisposition.WRITE_APPEND
    )

    job = client.load_table_from_dataframe(df, table_ref, job_config=job_config)
    job.result()  # Wait for the job to complete

    print(f"Successfully uploaded {len(df)} records to {table_ref}")


if __name__ == "__main__":
    DIRECTORY = "C:/Customer-Retail-Analytics/data/metro"
    CREDENTIALS_PATH = "C:/.keys/keyfile.json"
    PROJECT_ID = "soft-drink-grocery"
    DATASET_ID = "raw"
    TABLE_ID = "raw_metro_sales"

    try:
        df = load_csv_files(DIRECTORY)
        upload_to_bigquery(df, CREDENTIALS_PATH, PROJECT_ID, DATASET_ID, TABLE_ID)
    except Exception as e:
        print(f"Error: {e}")

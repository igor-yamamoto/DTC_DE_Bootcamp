#!/usr/bin/env python
# coding: utf-8

import os
import argparse

from time import time

import pandas as pd
from sqlalchemy import create_engine

from dotenv import load_dotenv

load_dotenv()

user = os.environ["PG_user"]
password = os.environ["PG_password"]
host = os.environ["PG_host"]
port = os.environ["PG_port"]
db = os.environ["PG_db"]

def main(params, user, password, host, port, db):
    table_name = params.table_name
    source_name = params.source_name
    url = params.url
    
    # the backup files are gzipped, and it's important to keep the correct extension
    # for pandas to be able to open the file
    if url.endswith('.csv.gz'):
        csv_name = 'output.csv.gz'
    else:
        csv_name = 'output.csv'

    print(f"Fetching data from: {url}")

    os.system(f"wget {url} -O {csv_name}")

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    df_iter = pd.read_csv(csv_name, iterator=True, chunksize=100000)

    df = preprocess_df(next(df_iter), source_name)

    df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')

    ingest_data(df, table_name, engine, source_name)

    while True: 

        try:
            t_start = time()
            
            df = preprocess_df(next(df_iter), source_name)

            ingest_data(df, table_name, engine, source_name)

            t_end = time()

            print('inserted another chunk, took %.3f second' % (t_end - t_start))

        except StopIteration:
            print("Finished ingesting data into the postgres database")
            break

def preprocess_df(df, source_name):
    if source_name == "yellow":
        df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
        df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)
    if source_name == "green":
        df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
        df.lpep_dropoff_datetime = pd.to_datetime(df.lpep_dropoff_datetime)

    return df

def ingest_data(df, table_name, engine, source_name):
    print(f"Inserting {source_name} dataset!")

    df.to_sql(name=table_name, con=engine, if_exists='append')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Ingest CSV data to Postgres')

    parser.add_argument('--table_name', required=True, help='name of the table where we will write the results to')
    parser.add_argument('--url', required=True, help='url for the data')
    parser.add_argument('--source_name', required=True, help='name of the source')

    args = parser.parse_args()

    main(args, user, password, host, port, db)
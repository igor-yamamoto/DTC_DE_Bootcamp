# DTC DE Bootcamp - Week 1

> [Directory for DTC's week 1 repo](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/week_1_basics_n_setup)

- [`docker`](./docker/): Codes used to spin up the PostgresSQL DB, as well as PGAdmin and the NY Taxi ingestion application. The last component was modified to support environment variables through `.env` files, and the default parameters in the [`docker-compose.yaml`](./docker/docker-compose.yaml) can be overwritten in runtime by building and running the service:
    ```bash
    $ docker-compose build ingest_data
    ...
    $ docker-compose run ingest_data \
        --url https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-01.csv.gz \
        --source_name green \
        --table_name green_taxi_trips
    ```
- [`terraform`](./terraform/): `.tf` files used to define and create the resources used in week 1. All the resources were defined in the [`main.tf`](./terraform/main.tf) file, which, as an extra exercise, was also used to spin up the compute instance with static external IP. 

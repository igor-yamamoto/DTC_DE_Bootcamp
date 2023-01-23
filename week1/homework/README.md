[Github link for questions](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2023/week_1_docker_sql/homework.md)

# Homework - Part I

# Question 1

## Question

Run the command to get information on Docker 

```docker --help```

Now run the command to get help on the "docker build" command

Which tag has the following text? - *Write the image ID to the file* 

- `--imageid string`
- `--iidfile string`
- `--idimage string`
- `--idfile string`

## Answer

Running `docker build --help` gives: 

```bash
$ docker build --help
...
      --disable-content-trust   Skip image verification (default true)
  -f, --file string             Name of the Dockerfile (Default is
                                'PATH/Dockerfile')
      --iidfile string          Write the image ID to the file
      --isolation string        Container isolation technology
      --label list              Set metadata for an image
      --network string          Set the networking mode for the RUN
                                instructions during build (default "default")
...
```

So, the tag that writes the image ID to the file is **`--iidfile string`**

# Question 2

## Question

Run docker with the python:3.9 image in an iterative mode and the entrypoint of bash.
Now check the python modules that are installed ( use pip list). 
How many python packages/modules are installed?

- 1
- 6
- 3
- 7

## Answer

By creating the following `Dockerfile`:

```Docker
FROM python:3.9

ENTRYPOINT [ "bash" ]
```

It is possible to build, run and check which python  packages were installed in the building process with an entrypoint set to bash:

```bash
$ docker build -t python_q_2:v001 .

...

$ docker run -it python_q_2:v001

$ root@28ebad5294b3:/ pip list
Package    Version
---------- -------
pip        22.0.4
setuptools 58.1.0
wheel      0.38.4
```

Therefore, the answer is **3**!

# Question 3

## Question

How many taxi trips were totally made on January 15?

Tip: started and finished on 2019-01-15. 

Remember that `lpep_pickup_datetime` and `lpep_dropoff_datetime` columns are in the format timestamp (date and hour+min+sec) and not in date.

- 20689
- 20530
- 17630
- 21090

## Answer

After inserting the datasets (green taxi trips from January 2019 AND the zones dataset) into the PostgreSQL's database, the following query gives the amount of trips made in January 15:

```sql
SELECT count(*) FROM public.green_taxi_trips
    WHERE lpep_pickup_datetime >= '2019-01-15 00:00:00' 
    AND lpep_pickup_datetime <= '2019-01-15 23:59:59'
    AND lpep_dropoff_datetime >= '2019-01-15 00:00:00' 
    AND lpep_dropoff_datetime <= '2019-01-15 23:59:59'
```

which gives **20530**!

# Question 4

## Question

Which was the day with the largest trip distance
Use the pick up time for your calculations.

- 2019-01-18
- 2019-01-28
- 2019-01-15
- 2019-01-10

## Answer

Based on the pick up time, the day that had the largest trip date can be retrieved by the following query:

```sql
select date_pu, max(trip_distance) max_distance
from (
        SELECT trip_distance,
            cast(green_taxi_trips.lpep_pickup_datetime AS date) date_pu
            FROM public.green_taxi_trips
    ) dist
group by date_pu
order by 2 desc
limit 1
```
which gives **2019-01-15** (distance: `117.99`)!

# Question 5

## Question

In 2019-01-01 how many trips had 2 and 3 passengers?
 
- 2: 1282 ; 3: 266
- 2: 1532 ; 3: 126
- 2: 1282 ; 3: 254
- 2: 1282 ; 3: 274

## Answer

The amount of trips hat had 2 and 3 passengers is given by the query:

```sql
SELECT passenger_count,
    count(*)
FROM public.green_taxi_trips
WHERE passenger_count in (2, 3)
    AND (
        (
            lpep_pickup_datetime >= '2019-01-01 00:00:00'
            AND lpep_pickup_datetime <= '2019-01-01 23:59:59'
        )
    )
GROUP BY passenger_count
```
which yields **1282** and **254** trips for 2 and 3 passengers, respectively!

# Question 6

## Question

For the passengers picked up in the Astoria Zone which was the drop up zone that had the largest tip?
We want the name of the zone, not the id.

Note: it's not a typo, it's `tip` , not `trip`

- Central Park
- Jamaica
- South Ozone Park
- Long Island City/Queens Plaza

## Answer

To find the trip with a pick up from Astoria zone that had the biggest tip:

> note: some fields were written with parenthesis due to capital letters in the name of the columns

```sql
SELECT z."Zone" "DOZone",
    tip.tip_amount
FROM (
        SELECT tt."DOLocationID",
            tt.tip_amount
        FROM public.green_taxi_trips tt
            inner join public.zones z on tt."PULocationID" = z."LocationID"
        where z."Zone" = 'Astoria'
    ) tip
    inner join public.zones z on tip."DOLocationID" = z."LocationID"

    order by tip.tip_amount DESC
    limit 1
```

which gives **Long Island City/Queens Plaza** as the drop off zone with the biggest tip (`88`)!

# Homework - Part II

# Question 1

## Question

In this homework we'll prepare the environment by creating resources in GCP with Terraform.

In your VM on GCP install Terraform. Copy the files from the course repo
[here](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/week_1_basics_n_setup/1_terraform_gcp/terraform) to your VM.

Modify the files as necessary to create a GCP Bucket and Big Query Dataset.

After updating the main.tf and variable.tf files run:

```
terraform apply
```

Paste the output of this command into the homework submission form.

## Answer

In order to run the `terraform apply` command, it was necessary to properly install Terraform on the VM instance, as well as transferring the files from local to cloud (both the `.tf` files, as well as the service account credentials).

After properly installing the dependencies and authenticating to gcloud, it was possible to run the `init`, `plan` and then finally the `terraform apply` command, which yielded as response:

```bash
user@de-zoomcamp:~/de-zoomcamp/week1/terraform$ terraform apply
var.project
  Your GCP Project ID

  Enter a value: --


Terraform used the selected providers to generate the following execution plan. Resource actions
are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_bigquery_dataset.dataset will be created
  + resource "google_bigquery_dataset" "dataset" {
      + creation_time              = (known after apply)
      + dataset_id                 = "trips_data_all_cloud"
      + delete_contents_on_destroy = false
      + etag                       = (known after apply)
      + id                         = (known after apply)
      + labels                     = (known after apply)
      + last_modified_time         = (known after apply)
      + location                   = "us-central1"
      + project                    = "--"
      + self_link                  = (known after apply)

      + access {
          + domain         = (known after apply)
          + group_by_email = (known after apply)
          + role           = (known after apply)
          + special_group  = (known after apply)
          + user_by_email  = (known after apply)

          + dataset {
              + target_types = (known after apply)

              + dataset {
                  + dataset_id = (known after apply)
                  + project_id = (known after apply)
                }
            }

          + routine {
              + dataset_id = (known after apply)
              + project_id = (known after apply)
              + routine_id = (known after apply)
            }

          + view {
              + dataset_id = (known after apply)
              + project_id = (known after apply)
              + table_id   = (known after apply)
            }
        }
    }

  # google_storage_bucket.data-lake-bucket will be created
  + resource "google_storage_bucket" "data-lake-bucket" {
      + force_destroy               = true
      + id                          = (known after apply)
      + location                    = "US-CENTRAL1"
      + name                        = "dtc_data_lake_cloud_--"
      + project                     = (known after apply)
      + public_access_prevention    = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + uniform_bucket_level_access = true
      + url                         = (known after apply)

      + lifecycle_rule {
          + action {
              + type = "Delete"
            }

          + condition {
              + age                   = 30
              + matches_prefix        = []
              + matches_storage_class = []
              + matches_suffix        = []
              + with_state            = (known after apply)
            }
        }

      + versioning {
          + enabled = true
        }

      + website {
          + main_page_suffix = (known after apply)
          + not_found_page   = (known after apply)
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

google_storage_bucket.data-lake-bucket: Creating...
google_bigquery_dataset.dataset: Creating...
google_bigquery_dataset.dataset: Creation complete after 0s [id=projects/--/datasets/trips_data_all_cloud]
google_storage_bucket.data-lake-bucket: Creation complete after 0s [id=dtc_data_lake_cloud_--]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

> Note 1: It was necessary to change the name of the resources (`dtc_data_lake` to `dtc_data_lake_cloud` and `trips_data_all` to `trips_data_all_cloud`) on the cloud because a former deployment was already made with the original names. 
> Note 2: As an exercise, I used terraform to deploy the VM instance itself instead of spinning it up through the GCP Console. As a result, the code in [main.tf](../terraform/main.tf) was the one used to spin up both the resources AND the VM, and the Terraform code used fo this exercise was from the [DataTalksClub's own Github Repo](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/week_1_basics_n_setup/1_terraform_gcp/terraform).
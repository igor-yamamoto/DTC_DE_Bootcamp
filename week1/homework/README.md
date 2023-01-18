[Github link for questions](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2023/week_1_docker_sql/homework.md)

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

To find the trip with a pick up from Astoria zone that hd the biggst tip:

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
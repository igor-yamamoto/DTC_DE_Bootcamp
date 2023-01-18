select date_pu, max(trip_distance) max_distance
from (
        SELECT trip_distance,
            cast(green_taxi_trips.lpep_pickup_datetime AS date) date_pu
            FROM public.green_taxi_trips
    ) dist
group by date_pu
order by 2 desc
limit 1

-- gives 2019-01-15: 117.99
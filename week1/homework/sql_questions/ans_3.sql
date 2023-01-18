SELECT count(*) FROM public.green_taxi_trips
WHERE lpep_pickup_datetime >= '2019-01-15 00:00:00' 
AND lpep_pickup_datetime <= '2019-01-15 23:59:59'
AND lpep_dropoff_datetime >= '2019-01-15 00:00:00' 
AND lpep_dropoff_datetime <= '2019-01-15 23:59:59'

-- gives 20530!!
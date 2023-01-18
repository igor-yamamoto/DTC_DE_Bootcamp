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
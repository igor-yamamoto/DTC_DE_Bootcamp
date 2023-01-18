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
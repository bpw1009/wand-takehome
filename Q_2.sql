-- Check Nulls
-- SELECT COUNT(*) AS total, COUNT(DISTINCT bikeid || CAST(starttime AS STRING)) AS distinct_trips
-- FROM `bigquery-public-data.new_york_citibike.citibike_trips`
-- WHERE EXTRACT(YEAR FROM starttime) = 2015;

-- Count distinct trips and use qualify with rank to get the start_station_id with the most trips
SELECT start_station_id, start_station_name, COUNT(DISTINCT bikeid || CAST(starttime AS STRING)) d_trips
FROM
`bigquery-public-data.new_york_citibike.citibike_trips` t

WHERE EXTRACT(YEAR FROM starttime) = 2015
GROUP BY 1,2
--ORDER BY 3 DESC

QUALIFY RANK() OVER(ORDER BY COUNT(*) DESC) = 1;


-- median trip length by usertype
SELECT DISTINCT usertype, PERCENTILE_CONT(tripduration, 0.5) OVER(PARTITION BY usertype) AS median_tripduration
FROM
`bigquery-public-data.new_york_citibike.citibike_trips` t

WHERE EXTRACT(YEAR FROM starttime) = 2015
AND usertype IS NOT NULL;


-- Get the pct of roundtrip trips using distinct inside the count to make robust to dups
SELECT ROUND(COUNT(DISTINCT CASE WHEN start_station_id = end_station_id THEN bikeid || CAST(starttime AS STRING) END) / 
        COUNT(DISTINCT bikeid || CAST(starttime AS STRING)) * 100.0,1) pct_roundtrip
FROM
`bigquery-public-data.new_york_citibike.citibike_trips` t

WHERE EXTRACT(YEAR FROM starttime) = 2015;

-- Adding usertype to the above query
SELECT usertype, ROUND(COUNT(DISTINCT CASE WHEN start_station_id = end_station_id THEN bikeid || CAST(starttime AS STRING) END) / 
        COUNT(DISTINCT bikeid || CAST(starttime AS STRING)) * 100.0,1) pct_roundtrip
FROM
`bigquery-public-data.new_york_citibike.citibike_trips` t

WHERE EXTRACT(YEAR FROM starttime) = 2015
GROUP BY 1;


-- q4
WITH t20 AS
(
SELECT start_station_id
FROM
`bigquery-public-data.new_york_citibike.citibike_trips`

WHERE EXTRACT(YEAR FROM starttime) = 2015
GROUP BY 1
QUALIFY RANK() OVER( ORDER BY COUNT(DISTINCT bikeid || CAST(starttime AS STRING)) DESC) <=20
),
am_pm AS
(
SELECT t.start_station_id, t.start_station_name,
  COUNT(DISTINCT
        CASE WHEN CAST(starttime AS TIME) BETWEEN '07:00:00' AND '10:00:00' THEN bikeid || CAST(starttime AS STRING) END
        ) / COUNT(DISTINCT bikeid || CAST(starttime AS STRING)) am_rush_hr,
  COUNT(DISTINCT
        CASE WHEN CAST(starttime AS TIME) BETWEEN '16:00:00' AND '19:00:00' THEN bikeid || CAST(starttime AS STRING) END
        ) / COUNT(DISTINCT bikeid || CAST(starttime AS STRING)) pm_rush_hr
FROM
`bigquery-public-data.new_york_citibike.citibike_trips` t
JOIN 
t20
ON t.start_station_id = t20.start_station_id
WHERE EXTRACT(YEAR FROM starttime) = 2015
AND EXTRACT(DAYOFWEEK FROM starttime) BETWEEN 2 AND 6
GROUP BY 1,2
)
SELECT start_station_id, start_station_name, am_rush_hr, pm_rush_hr, ABS(am_rush_hr - pm_rush_hr) abs_diff

FROM am_pm
-- ORDER BY 5 DESC
QUALIFY RANK() OVER(ORDER BY ABS(am_rush_hr - pm_rush_hr) DESC) = 1
# Wand Take-Home: Product Analyst

Deliverables for the Wand Product Analyst take-home assignment. The writeup covers both questions; this repo holds the code, queries, and maps behind Question 2.

## Contents

| File | What it is |
|---|---|
| `writeup.md` | Full writeup for both questions. Recommendations first, limitations last. |
| `citibike_questions.ipynb` | Question 2 end to end: Part A queries with results, Part B exploration, segmentation, and maps. Uses the BigQuery Python client. |
| `Q_2.sql` | The four Part A queries as standalone SQL, runnable directly in BigQuery. |
| `top_stations_map.png` / `.html` | Top 10 start stations by user type (Subscribers blue, Customers red). |
| `subscriber_routes.png` / `.html` | Top 10 Subscriber routes. |
| `customer_routes.png` / `.html` | Top 10 Customer routes. Round trips shown as green diamonds. |

The `.html` maps are interactive (folium); GitHub does not render them, so each has a `.png` snapshot next to it. Clone and open the `.html` files locally to explore.

## Year choice

All of Part A uses **full-year 2015** on the full dataset. I originally started with 2017 and discovered partway through that the public dataset is missing January through March of that year. Only 2014 and 2015 have full 12-month coverage, so I pivoted to 2015. The abandoned 2017 work is preserved on the `2017_branch` branch since the assignment mentioned failed branches are interesting.

Part B uses a deterministic 10% sample of 2015 (about 997K trips) pulled via `FARM_FINGERPRINT` for fast local exploration in pandas. Part A numbers were computed on the full dataset.

## Re-running

1. `pip install google-cloud-bigquery pydata-google-auth db-dtypes folium`
2. Set `project` in the notebook to your own GCP project ID (billing for the public dataset queries runs through your project).
3. Run top to bottom. The first cell authenticates through your browser. The 10% sample pull takes about 3.5 minutes to load into pandas; everything after runs in seconds.

`Q_2.sql` needs no setup; paste into the BigQuery console.

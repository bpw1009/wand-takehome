# Wand Take-Home: Product Analyst

Ben Weckerle

Code, queries, and interactive maps: [github.com/bpw1009/wand-takehome](https://github.com/bpw1009/wand-takehome)

Question 2 uses full-year 2015 of the NYC Citi Bike public dataset (see the Year Choice note in Question 2 and the README).

---

## Recommendations

**Question 1:** Game Guide product-market fit should be measured on deep-integrated titles first. That's where the differentiated product lives. The most important metric for PMF is Game Guide Penetration Rate. This rate focuses on users where the product is delivering the most value and receiving the most investment.

> **Game Guide Penetration Rate** = (weekly average Game Guide users on deep-integration titles) / (weekly average users playing deep-integration titles)

**Question 2:** Subscribers and Customers are two distinct segments: commuters and tourists with different usage patterns, geographies, and time profiles. Subscribers account for most of the revenue and trips while Customers represent a clear growth opportunity. Product should optimize the Subscriber experience by integrating with transit systems to give Subscribers live bike availability near their destinations. For Customers, the product team should develop features that detect tourist behavior, such as a Lyft ride from an airport to a hotel near Central Park, and promote leisure bike options at that moment.

Part A at a glance (2015): busiest start station was Pershing Square North (104,813 trips); median trip duration was 20.5 min for Customers vs 9.6 min for Subscribers; 2% of trips were round trips (5.9% Customer vs 1.5% Subscriber); the most lopsided rush-hour station in the top 20 was 8 Ave & W 31 St, heavily AM-skewed next to Penn Station.

---

## Question 1: Is Game Guide Hitting PMF?

### Opening

I've been using Game Guide with Cyberpunk 2077 on a PC with an Xbox controller. In my experience, I've found Game Guide to be truly helpful for quickly querying controls (how to switch to 3rd person camera while driving, how to maneuver the character, etc.) and when stuck on missions. Probably with most users, there is some form of both of these types of uses: getting oriented in the game and figuring out controls, and finding out where and how to progress in the game and on missions. As such, usage will be heaviest early and taper over time (right-skewed), with this pattern resetting if a user takes a break and returns to the game after a few months or so.

Also, there will likely be a noticeable difference between deep-integrated titles compared to titles where the bot is searching the internet for answers. The integrated titles should plateau and remain somewhat steady until users finish the game, whereas the generic titles likely show an initial bump before dropping closer to zero usage.

As far as defining usage, I would say that there needs to be at least one question asked over the user's game history to start tracking usage. After meeting that threshold, usage could be counted as asking a question during a session *or* scrolling up to view a previously answered question. I have found myself reviewing answers I've asked before by scrolling up.

With these considerations in mind, Game Guide product-market fit should be primarily focused on deep-integrated titles first. This is where users will get the most value. The generic guide usage should be treated as a signal for which titles to build out deep integration next.

### Defining Product-Market Fit

Product-market fit for Game Guide, which is being rolled out in a phased launch (some deep-integrated titles, some generic-search titles, some remaining unsupported), should not be an aggregated measure with all Wand users as the denominator. Instead, market fit should focus on the deep-integrated titles, since that's where the product can provide the most value that can't be found somewhere else (navigating to a wiki or asking ChatGPT).

### The One Metric That Matters

> **Game Guide Penetration Rate** = (weekly average Game Guide users on deep-integration titles) / (weekly average users playing deep-integration titles)

With this metric, we can see if users are responding to the investment that the product team and developers are making in the product, and we can see if the value Wand believes it is providing is met by user demand.

In Ron Kohavi's terms, penetration rate is my candidate OEC (Overall Evaluation Criterion) for Game Guide at this stage, with disable rate as the guardrail. The long-run test of the whole framework is whether Game Guide usage causally improves Wand retention and Pro conversion, in other words lifetime value. That is exactly what the quasi-experimental analysis proposed at the end of this section is designed to check.

### Supporting Metrics

- **Query mix ratio**: orientation queries (controls, etc.) vs. stuck queries (mission walkthroughs).
- **Repeat session rate**: share of queriers that come back (at all, not just the next day).
- **Follow-up query rate / wrong answer rate** (quality proxy): I experienced a wrong answer when I asked what button to use.
- **Deep-integrated vs. generic title answer quality**: if there is a large gap between integrated title answer quality and generic title answer quality, that supports the idea that the roadmap should prioritize more integrations.
- **Disable rate** (guardrail): players can turn Game Guide off entirely and that's tracked. A rising disable rate on deep-integrated titles overrides any good news in the other metrics.

### What Does PMF Look Like vs. Not There Yet?

**PMF:** Retention curve flattens on deep-integration titles, query mix shifts toward stuck queries over the user lifecycle, repeat session rate is stable or growing, disable rate is low and declining.

**Not there yet:** Usage is heavy early on and drops close to zero. The deep-integrated title usage shape looks similar to generic title usage. This would mean the deep integration (and the development investment) isn't adding value yet.

### What Metrics to Distrust

- **Total query volume**: could be gamed by push prompts and one-time users.
- **MAU**: meaningless without a good denominator.
- **Early use of surveys**: too noisy at this point.
- **Mods cross-selling conversions**: Game Guide should be measured on its own value, not just whether it drives mod usage.

### First Analysis With a Week and Full Data: Synthetic Control

If I had a week with the data, I'd set up a synthetic control quasi-experiment. A synthetic control compares a treated unit, say Cyberpunk 2077, to a weighted combination of other units that make up a makeshift experimental control. This technique is used in cases where A/B tests are not feasible.

A couple of options to test:

- Did the deep-integrated Game Guide in Cyberpunk 2077 increase Game Guide retention compared to games that had the generic guide?
- Did Game Guide (any version) improve Wand retention compared to games where Game Guide is not supported?

---

## Question 2: Citi Bike Investigation

### Year choice

All of Part A uses **full-year 2015** on the full dataset. I started with 2017 and discovered partway through that the public dataset is missing January through March of that year. Only 2014 and 2015 have full 12-month coverage, so I pivoted to 2015. The abandoned 2017 exploration is preserved on `2017_branch` in the repo.

Part B uses a deterministic 10% sample of 2015 (~997K trips) pulled via `FARM_FINGERPRINT` for fast exploration in pandas; Part A numbers come from the full dataset. Queries for each answer below are in `Q_2.sql` (labeled in the same order) and in `citibike_questions.ipynb` with their outputs.

### Part A: Factual

**A1. Busiest start station.** Pershing Square North, with **104,813 trips**. It sits adjacent to Grand Central, which makes sense for a commuter hub.

**A2. Median trip duration by user type.** Customers ride a median of **20.5 minutes** vs **9.6 minutes** for Subscribers. The gap reflects different use cases: Subscribers are commuters doing short point-to-point trips, Customers are casual and tourist riders on longer leisure trips.

**A3. Round trip share.** **2% overall: 5.9% for Customers vs 1.5% for Subscribers.** Citi Bike is designed for one-way trips. Round trips are almost entirely a leisure behavior, which is why Customers are roughly 4x more likely to take them.

**A4. Most lopsided rush-hour station.** Among the top 20 start stations, **8 Ave & W 31 St** is the most lopsided and is overwhelmingly AM-heavy: **50.0% of weekday trips start in the 7-10am window vs 10.4% in the 4-7pm window**. I define "lopsided" as the absolute percentage-point difference between the AM and PM rush-hour shares, which makes stations easy to rank by magnitude regardless of direction. The station is right next to Penn Station, suggesting commuters arrive at Penn and bike the last leg to work. The next most lopsided station, W 42 St & 8 Ave, is also AM-heavy and sits by Port Authority Bus Terminal, another major commuter hub.

### Part B: The Two User Types Tell Different Stories

Citi Bike Subscribers and Customers show clearly different behavior. Subscribers are using the bikes to get to and from major commuter hubs, and Customers are using the bikes for leisure. Customers stick to tourist areas with green space and water like Central Park, the Hudson River Esplanade, and the Brooklyn Bridge. At the same time, Customers avoid high-density pedestrian areas like Times Square despite heavy tourist foot traffic, suggesting station placement should prioritize bikeability over proximity to attractions. There's a clear opportunity to grow the Customer segment, which represents only 13% of trips.

Knowing these usage patterns, and given the current Lyft ownership, I would recommend leveraging the business relationship with Lyft to send alerts and promotions to people exhibiting tourist patterns. For instance, a Lyft ride booked from an airport to a hotel (especially a hotel near Central Park or the Brooklyn Bridge, where many Customer rides start) could trigger an alert or a discount, either in the Citi Bike app directly or through Lyft's app. Notifications through Lyft's app would be an excellent way to reach new users.

A related idea would be to retarget Citi Bike Customers who used bikes while visiting New York after they return to their home city. For instance, a notification could be sent with the top scenic Bay Wheels trips in the Bay Area (Bay Wheels is a bike share also owned by Lyft). The reverse notification could also work: a New Yorker who used Bay Wheels for leisure could get a notification after coming back to NY.

For the Subscriber side, which makes up the bulk of the revenue and is heavily commuter-focused, it makes sense to roll out a transit integration. If the app knows you're on a specific train heading toward Penn Station, it could show real-time bike counts near your destination and offer backup pickup locations.

To help with lifetime value and retention, we can also use the seasonal patterns to reduce churn. If a user starts the subscription cancellation flow, the app could offer a pause instead. We know the fewest trips happen in January and February, so the subscription could be set to restart in March or April when trips pick back up.

Furthermore, to keep stock balanced, continue to gamify and incentivize returning bikes to stations that are low. The lopsided rush-hour analysis shows stations like 8 Ave & W 31 St near Penn Station emptying out by 10am. Incentivizing riders to return bikes to depleted stations during peak hours could capture demand that would otherwise go unmet, as well as reduce rebalancing costs.

---

## Limitations

**Q1.** There was no actual data for this question, so the framework, as well as the hypothesis around orientation vs stuck-in-the-game queries, is directional and would need to be validated. Game completion also creates natural churn that can look like product failure; a system for detecting game completion would help here. Lastly, answer quality is hard to measure, and follow-up queries aren't a perfect proxy for it.

**Q2.** For efficient exploratory analysis, Part B uses a 10% deterministic sample (via BigQuery's `FARM_FINGERPRINT` hash), which keeps less in memory in pandas while preserving the statistical patterns; Part A uses the full dataset. Very short trips under 3-4 minutes are likely failed checkouts rather than real usage. The first year I looked at, 2017, had no data for the first three months, so I pivoted to 2015 to use a full year. My recommendations are mostly testable via user-level A/B tests; station-level changes would need quasi-experimental designs, and Citi Bike-wide changes would be the hardest to test, though given Lyft's ownership of bike shares in other cities, a synthetic control using a combination of other cities as the control is plausible.

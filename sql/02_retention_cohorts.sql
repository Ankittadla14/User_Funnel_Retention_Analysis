-- 02_retention_cohorts.sql
-- Cohort retention: D1 and D7 based on signup_date
-- Assumes events has event_date (DATE) and signup event exists per user.

WITH signup AS (
  SELECT user_id, MIN(event_date) AS signup_date
  FROM events
  WHERE event_name = 'signup'
  GROUP BY 1
),
activity AS (
  SELECT DISTINCT e.user_id, e.event_date
  FROM events e
  WHERE e.event_name IN ('view_feed','like','comment','share')
),
retention AS (
  SELECT
    s.user_id,
    s.signup_date,
    MAX(CASE WHEN a.event_date = s.signup_date + INTERVAL '1 day' THEN 1 ELSE 0 END) AS d1_retained,
    MAX(CASE WHEN a.event_date = s.signup_date + INTERVAL '7 day' THEN 1 ELSE 0 END) AS d7_retained
  FROM signup s
  LEFT JOIN activity a ON a.user_id = s.user_id
  GROUP BY 1,2
)
SELECT
  signup_date,
  COUNT(*) AS cohort_users,
  AVG(d1_retained) AS d1_retention,
  AVG(d7_retained) AS d7_retention
FROM retention
GROUP BY 1
ORDER BY 1;

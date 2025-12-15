-- 03_segment_breakdowns.sql
-- Segment cuts by country/device for funnel & retention

WITH signup AS (
  SELECT user_id,
         MIN(event_date) AS signup_date,
         ANY_VALUE(country) AS country,
         ANY_VALUE(device_type) AS device_type
  FROM events
  WHERE event_name='signup'
  GROUP BY 1
),
base AS (
  SELECT
    s.country,
    s.device_type,
    s.user_id,
    MAX(CASE WHEN e.event_name='onboarding_complete' THEN 1 ELSE 0 END) AS onboarded,
    MAX(CASE WHEN e.event_name IN ('add_friend','follow_creator') THEN 1 ELSE 0 END) AS activated,
    MAX(CASE WHEN e.event_name IN ('view_feed','like','comment','share') THEN 1 ELSE 0 END) AS engaged
  FROM signup s
  LEFT JOIN events e ON e.user_id = s.user_id
  GROUP BY 1,2,3
),
activity AS (
  SELECT DISTINCT user_id, event_date
  FROM events
  WHERE event_name IN ('view_feed','like','comment','share')
),
ret AS (
  SELECT
    s.country,
    s.device_type,
    s.user_id,
    MAX(CASE WHEN a.event_date = s.signup_date + INTERVAL '1 day' THEN 1 ELSE 0 END) AS d1_retained,
    MAX(CASE WHEN a.event_date = s.signup_date + INTERVAL '7 day' THEN 1 ELSE 0 END) AS d7_retained
  FROM signup s
  LEFT JOIN activity a ON a.user_id=s.user_id
  GROUP BY 1,2,3
)
SELECT
  b.country,
  b.device_type,
  COUNT(*) AS users,
  AVG(b.onboarded) AS onboarding_rate,
  AVG(b.activated) AS activation_rate,
  AVG(b.engaged) AS engagement_rate,
  AVG(r.d1_retained) AS d1_retention,
  AVG(r.d7_retained) AS d7_retention
FROM base b
JOIN ret r ON r.user_id=b.user_id AND r.country=b.country AND r.device_type=b.device_type
GROUP BY 1,2
ORDER BY users DESC;

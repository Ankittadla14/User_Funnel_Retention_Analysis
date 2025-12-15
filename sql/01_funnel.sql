-- 01_funnel.sql
-- Funnel: signup -> onboarding_complete -> activation -> engaged
-- Assumes table: events(user_id, event_time, event_date, event_name, country, device_type)

WITH base AS (
  SELECT
    user_id,
    MIN(CASE WHEN event_name = 'signup' THEN event_time END) AS signup_time,
    MIN(CASE WHEN event_name = 'onboarding_complete' THEN event_time END) AS onboarding_time,
    MIN(CASE WHEN event_name IN ('add_friend','follow_creator') THEN event_time END) AS activation_time,
    MIN(CASE WHEN event_name IN ('view_feed','like','comment','share') THEN event_time END) AS engage_time
  FROM events
  GROUP BY 1
),
funnel AS (
  SELECT
    COUNT(*) AS signed_up,
    SUM(CASE WHEN onboarding_time IS NOT NULL THEN 1 ELSE 0 END) AS onboarded,
    SUM(CASE WHEN activation_time IS NOT NULL THEN 1 ELSE 0 END) AS activated,
    SUM(CASE WHEN engage_time IS NOT NULL THEN 1 ELSE 0 END) AS engaged
  FROM base
)
SELECT
  signed_up,
  onboarded,
  activated,
  engaged,
  onboarded * 1.0 / signed_up AS onboarding_rate,
  activated * 1.0 / signed_up AS activation_rate,
  engaged * 1.0 / signed_up AS engagement_rate
FROM funnel;

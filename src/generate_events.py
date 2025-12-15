"""
generate_events.py

Generates synthetic product analytics event logs for:
- Funnel analysis
- Cohort retention (D1/D7)
"""

from __future__ import annotations
import numpy as np
import pandas as pd
from datetime import datetime, timedelta

def generate_events(n_users: int = 60000, days: int = 21, seed: int = 42) -> pd.DataFrame:
    rng = np.random.default_rng(seed)

    countries = np.array(["US","IN","BR","MX","GB","CA","DE","FR","JP","AU"])
    country_probs = np.array([0.35,0.18,0.09,0.06,0.07,0.06,0.06,0.05,0.05,0.03])
    devices = np.array(["iOS","Android","Web"])
    device_probs = np.array([0.42,0.48,0.10])

    user_ids = np.arange(1, n_users + 1)
    user_country = rng.choice(countries, size=n_users, p=country_probs)
    user_device = rng.choice(devices, size=n_users, p=device_probs)

    start = datetime(2025, 11, 1)
    signup_offsets = rng.integers(0, max(days-7, 1), size=n_users)
    signup_dates = np.array([start + timedelta(days=int(d)) for d in signup_offsets], dtype="datetime64[ns]")

    propensity = rng.lognormal(mean=0.0, sigma=0.7, size=n_users)

    rows = []
    for i, uid in enumerate(user_ids):
        sd = pd.Timestamp(signup_dates[i])
        country = user_country[i]
        device = user_device[i]
        prop = propensity[i]

        # signup
        rows.append((uid, sd + pd.Timedelta(minutes=int(rng.integers(0, 180))), sd.date(), "signup", country, device))

        # funnel probabilities
        p_onboard = np.clip(0.78 + 0.05*(prop>1.2) - 0.04*(device=="Web"), 0.55, 0.92)
        p_activate = np.clip(0.52 + 0.07*(prop>1.3) - 0.05*(country=="IN"), 0.25, 0.80)
        p_engage = np.clip(0.62 + 0.08*(prop>1.1) - 0.05*(device=="Web"), 0.35, 0.90)

        onboarded = rng.random() < p_onboard
        activated = onboarded and (rng.random() < p_activate)
        engaged = activated and (rng.random() < p_engage)

        if onboarded:
            t = sd + pd.Timedelta(hours=int(rng.integers(1, 36)))
            rows.append((uid, t, t.date(), "onboarding_complete", country, device))

        if activated:
            t = sd + pd.Timedelta(hours=int(rng.integers(2, 72)))
            rows.append((uid, t, t.date(), rng.choice(["add_friend","follow_creator"]), country, device))

        if engaged:
            n_views = int(rng.poisson(lam=np.clip(3.5 * (prop**0.4), 1.0, 12.0)))
            for _ in range(n_views):
                t = sd + pd.Timedelta(hours=int(rng.integers(3, 24)), minutes=int(rng.integers(0, 60)))
                rows.append((uid, t, t.date(), "view_feed", country, device))

            n_actions = int(rng.poisson(lam=np.clip(1.2 * (prop**0.45), 0.0, 6.0)))
            for _ in range(n_actions):
                t = sd + pd.Timedelta(hours=int(rng.integers(3, 24)), minutes=int(rng.integers(0, 60)))
                rows.append((uid, t, t.date(), rng.choice(["like","comment","share"], p=[0.75,0.18,0.07]), country, device))

        # retention events
        base_d1 = 0.40 + 0.10*(engaged) + 0.06*(prop>1.2)
        base_d7 = 0.28 + 0.08*(engaged) + 0.05*(prop>1.3)

        if rng.random() < np.clip(base_d1, 0.08, 0.85):
            d1 = sd + pd.Timedelta(days=1)
            t = d1 + pd.Timedelta(hours=int(rng.integers(0, 18)), minutes=int(rng.integers(0, 60)))
            rows.append((uid, t, t.date(), "view_feed", country, device))

        if rng.random() < np.clip(base_d7, 0.05, 0.70):
            d7 = sd + pd.Timedelta(days=7)
            t = d7 + pd.Timedelta(hours=int(rng.integers(0, 18)), minutes=int(rng.integers(0, 60)))
            rows.append((uid, t, t.date(), "view_feed", country, device))

    events = pd.DataFrame(rows, columns=["user_id","event_time","event_date","event_name","country","device_type"])
    events["event_time"] = pd.to_datetime(events["event_time"])
    events["event_date"] = pd.to_datetime(events["event_date"]).dt.date
    return events

## Stats

This script aggregates some useful stats about all active machines. Rented counts and average_min_bid are not completely accurate as not enough data from the API is given to calculate bids. Estimated profit includes fees and also uses rented_percent as a measure of how much it will be rented.

Install dependencies
```bash
pip install -r requirements.txt
```

Run
```bash
python stats.py
```

Example Output
```json
{
    "global_stats": {
        "is_rented_percent": 62.67,
        "average": {
            "dl_speed": 308,
            "ul_speed": 216,
            "num_gpus": 3.58,
            "dlperf": 40,
            "dlperf_per_dphtotal": 67,
            "reliability": 0.975
        },
        "counts": {
            "machines": 150,
            "machines_rented": 94,
            "gpus": 537,
            "cuda": {
                "11.0": 66,
                ...
            },
            "mobo": {
                "Z10PE": 13,
                ...
            },
            "cpu": {
                "AMD Ryzen Threadripper 1900X 8-Core Processor": 8,
                ...
            }
        }
    },
    "gpus": {
        "RTX 2080 Ti": {
            "price": {
                "average": 0.224,
                "average_min_bid": 0.21,
                "max": 0.4,
                "min": 0.15
            },
            "rented_percent": 85.71,
            "market_share": 22.16,
            "average_dlperf": 18.92,
            "num_gpus": 119,
            "rented_num": 102,
            "estimated_profit_per_month": 103.67
        }
    }
}
```

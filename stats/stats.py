import json
import collections
import requests

response = requests.get('https://vast.ai/api/v0/bundles/?q={"disk_space":{"gte":0},"reliability2":{},"duration":{},"rentable":{},"external":{"eq":false},"verified":{},"dph_total":{},"flops_per_dollar":{},"num_gpus":{},"total_flops":{},"gpu_ram":{},"gpu_mem_bw":{},"pcie_bw":{},"cpu_cores_effective":{},"cpu_ram":{},"disk_bw":{},"inet_up":{"gte":0},"inet_down":{"gte":0},"order":[["score","desc"]],"allocated_storage":0,"extra_ids":[],"type":"ask"}')
data = response.json()

machines = {}
averages = {}
counts = {}
gpus = {}
min_max = {}

def count(key, value, sub_key=-1):
    if key not in counts:
        if sub_key != -1:
            counts[key] = {}
        else:
            counts[key] = 0

    if sub_key != -1:
        if sub_key not in counts[key]:
            counts[key][sub_key] = 0

        counts[key][sub_key] += value
    else:
        counts[key] += value

def track_average(key, value):
    if key not in averages:
        averages[key] = []

    averages[key].append(value)

def get_average(key):
    item = averages[key]
    return sum(item) / len(item)

def arrange(list):
    return collections.OrderedDict(sorted(list.items(), key=lambda x: x[1], reverse=True))

def track_min_max(key, value):
    if key not in min_max:
        min_max[key] = {
            "min": value,
            "max": value
        }

    if value < min_max[key]['min']:
        min_max[key]['min'] = value

    if value > min_max[key]['max']:
        min_max[key]['max'] = value

for item in data['offers']:
    if item['machine_id'] not in machines or item['num_gpus'] > machines[item['machine_id']]['num_gpus']:
        machines[item['machine_id']] = item


for id in machines:
    machine = machines[id]
    count("total_machines", 1)
    count("total_gpus", machine['num_gpus'])
    count("cuda_max_good", 1, sub_key=machine['cuda_max_good'])
    count("mobos", 1, sub_key=machine['mobo_name'])
    count("cpus", 1, sub_key=machine['cpu_name'])
    track_average("ul_speed", machine['inet_up'])
    track_average("dl_speed", machine['inet_down'])
    track_average("dlperf", machine['dlperf'])
    track_average("dlperf_per_dphtotal", machine['dlperf_per_dphtotal'])
    track_average("num_gpus", machine['num_gpus'])
    track_average("reliability", machine['reliability2'])

    gpu_name = machine['gpu_name']

    if gpu_name not in gpus:
        gpus[gpu_name] = {
            "price": {},
            "rented_percent": 0,
            "market_share": 0,
            "average_dlperf": 0,
            "num_gpus": 0
        }

    single_price = machine['dph_base'] / machine['num_gpus']
    single_bid = machine['min_bid'] / machine['num_gpus']

    track_average("gpu_average_price_" + gpu_name, single_price)
    track_average("gpu_average_dlperf_" + gpu_name, machine['dlperf'] / machine['num_gpus'])
    track_average("gpu_average_min_bid_" + gpu_name, single_bid)
    track_min_max("gpu_price_" + gpu_name, single_price)

    if not machine['rentable'] or machine['rented'] == True:
        count("total_machines_rented", 1)
        count("gpus_rented_" + gpu_name, machine['num_gpus'])

    gpus[gpu_name]['num_gpus'] += machine['num_gpus']


for item in gpus:
    gpu = gpus[item]
    _min_max = min_max["gpu_price_" + item]

    gpus[item]['price'] = {
        "average": round(get_average('gpu_average_price_' + item), 3),
        "average_min_bid": round(get_average('gpu_average_min_bid_' + item), 3),
        "max": _min_max['max'],
        "min": _min_max['min'],
    }

    gpus[item]['average_dlperf'] = round(get_average('gpu_average_dlperf_' + item), 2)
    gpus[item]['market_share'] = round((gpu['num_gpus'] / counts['total_gpus']) * 100, 2)

    if 'gpus_rented_' + item in counts:
        gpus[item]['rented_percent'] = round((counts['gpus_rented_' + item] / gpu['num_gpus']) * 100, 2)
        gpus[item]['rented_num'] = counts['gpus_rented_' + item]

    gpus[item]['estimated_profit_per_month'] = round((gpus[item]['price']['average'] * 24 * 30) * (gpus[item]['rented_percent'] / 100) * 0.75, 2)

output = {
    "global_stats": {
        "is_rented_percent": round((counts['total_machines_rented'] / counts['total_machines']) * 100, 2),
        "average": {
            "dl_speed": int(get_average("dl_speed")),
            "ul_speed": int(get_average("ul_speed")),
            "num_gpus": round(get_average("num_gpus"), 2),
            "dlperf": int(get_average("dlperf")),
            "dlperf_per_dphtotal": int(get_average("dlperf_per_dphtotal")),
            "reliability": round(get_average("reliability"), 3),
        },
        "counts": {
            "machines": counts['total_machines'],
            "machines_rented": counts['total_machines_rented'],
            "gpus": counts['total_gpus'],
            "cuda": arrange(counts['cuda_max_good']),
            "mobo": arrange(counts['mobos']),
            "cpu": arrange(counts['cpus'])
        }
    },
    "gpus": gpus
}

print(json.dumps(output, indent=4))

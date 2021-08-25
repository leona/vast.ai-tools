import json

class Encodable:
    def __init__(self, **kwargs):
        for item in kwargs:
            if hasattr(self, item):
                self.__dict__[item] = kwargs[item]

    def toJson(self):
        return json.dumps(self, default=lambda o: o.__dict__)

class HwStat(Encodable):
    utilisation: float = None
    max_utilisation: float = None
    temp: int = None
    power: int = None

class LocalStat(Encodable):
    gpu: HwStat = None
    ram: HwStat = None
    cpu: HwStat = None

class User(Encodable):
    credit: float = None

class Instance(Encodable):
    id: int = None
    is_bid: str = None
    rentable: bool = None
    min_bid: float = None
    dph_base: float = None
    dph_total: float = None
    actual_status: str = None
    intended_status: str = None
    cur_state: str = None
    next_state: str = None
    gpu_util: int = None
    gpu_temp: int = None
    local: LocalStat = None

class Machine(Encodable):
    id: int = None
    timeout: int = None
    num_gpus: int = None
    gpu_name: str = None
    listed_min_gpu_count: int = None
    listed_gpu_cost: float = None
    listed_storage_cost: float = None
    listed_inet_up_cost: float = None
    listed_inet_down_cost: float = None
    disk_bw: float = None
    bid_gpu_cost: float = None
    disk_space: int = None
    current_rentals_running: int = None
    current_rentals_running_on_demand: int = None
    current_rentals_resident: int = None
    current_rentals_on_demand: int = None
    reliability2: float = None
    local: LocalStat = None

class Log(Encodable):
    user: User = None
    machine: Machine = None
    time: int = None

class Balance(Encodable):
    charges: float = None
    serice_fee: float = None
    total: float = None
    credit: float = None

class Account(Encodable):
    email: str = None
    current: Balance = None

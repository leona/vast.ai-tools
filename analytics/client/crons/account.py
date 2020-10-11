import json
import requests
import settings
from lib.vast import Vast
from lib.sys import log
from models import vast as models
import os
import time
from lib.database import Database
from lib.decorators import set_interval

def run():
    vast = Vast(username=settings.VAST_USERNAME, password=settings.VAST_PASSWORD)
    account = vast.get_account()
    machine = vast.get_machine(id=settings.VAST_MACHINE_ID)
    machine.instances = vast.get_instances(machine_id=settings.VAST_MACHINE_ID)

    db = Database()
    _time = int(time.time())

    db.insert_machine(_time, {
        "machine_id": machine.id,
        "account_credit": account.current['total'],
        "reliability": machine.reliability2,
        "rentals_stored": machine.current_rentals_resident,
        "rentals_on_demand": machine.current_rentals_running_on_demand,
        "rentals_bid":  machine.current_rentals_running - machine.current_rentals_running_on_demand
    })

    for key, instance in enumerate(machine.instances):
        db.insert_instance(_time, {
            "machine_id": machine.id,
            "instance_id": key,
            "earning":  0 if instance.next_state == "running" else instance.min_bid,
        })

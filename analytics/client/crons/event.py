from lib.database import Database
import time
import settings

def run():
    db = Database()

    values = [None, None, None, None]

    for key, item in enumerate(settings.args.values.split(",")):
        if len(item) > 45:
            item = item[0:44]

        if key not in values:
            log("WARNING - Key:", key, "not in values:", values)
            continue

        values[key] = item

    db.insert_event({
        "time": settings.args.time,
        "name": settings.args.name,
        "val1": values[0],
        "val2": values[1],
        "val3": values[2],
        "val4": values[3],
    })

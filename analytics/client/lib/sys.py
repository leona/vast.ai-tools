from datetime import datetime, timedelta

def get_time():
    return (datetime.now() + timedelta(hours=2)).strftime('%d/%m %H:%M:%S')

def log(*args, **kwargs):
    print(get_time() + " --> "+" ".join(map(str,args)), **kwargs)

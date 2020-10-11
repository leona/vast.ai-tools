import os

VAST_MACHINE_ID = int(os.getenv("VAST_MACHINE_ID"))
VAST_USERNAME = os.getenv("VAST_USERNAME")
VAST_PASSWORD = os.getenv("VAST_PASSWORD")
DB_HOST = os.getenv("DB_HOST")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_NAME = os.getenv("DB_NAME")
LOG_SYS_INTERVAL = int(os.getenv("LOG_SYS_INTERVAL"))
LOG_ACC_INTERVAL = int(os.getenv("LOG_ACC_INTERVAL"))

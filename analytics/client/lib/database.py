import mysql.connector
from lib.sys import log
import settings

db = mysql.connector.connect(
  host=settings.DB_HOST,
  user=settings.DB_USER,
  password=settings.DB_PASSWORD,
  database=settings.DB_NAME
)

class Database:

    def cursor(self):
        return db.cursor()

    def exec(self, query, values):
        cur = self.cursor()
        cur.execute(query, values)
        db.commit()
        cur.close()

    def insert_event(self, data):
        log("Inserting event:", data)
        query = "INSERT INTO event (time, name, val1, val2, val3, val4) VALUES(%s, %s, %s, %s, %s, %s)"
        values = (data['time'], data['name'], data['val1'], data['val2'], data['val3'], data['val4'])
        self.exec(query, values)

    def insert_machine(self, time, data):
        log("Inserting machine:", data)
        query = "INSERT INTO machine (time, machine_id, account_credit, reliability, rentals_stored, rentals_on_demand, rentals_bid) VALUES(%s, %s, %s, %s, %s, %s, %s)"
        values = (time, data['machine_id'], data['account_credit'], data['reliability'], data['rentals_stored'], data['rentals_on_demand'], data['rentals_bid'])
        self.exec(query, values)

    def insert_instance(self, time, data):
        log("Inserting instance:", data)
        query = "INSERT INTO instance (time, machine_id, instance_id, earning) VALUES(%s, %s, %s, %s)"
        values = (time, data['machine_id'], data['instance_id'], data['earning'])
        self.exec(query, values)

    def insert_hardware(self, time, data):
        log("Inserting hardware:", data)
        query = "INSERT INTO hardware (time, component, hw_id, utilisation, temperature, power_consumption) VALUES(%s, %s, %s, %s, %s, %s)"
        values = (time, data['component'], data['hw_id'], data['utilisation'], data['temperature'], data['power_consumption'])
        self.exec(query, values)

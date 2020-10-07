import requests
import os

def telegram_request(path):
    response = requests.get("https://api.telegram.org/bot" + os.getenv('TELEGRAM_TOKEN') + path)
    return response.json()

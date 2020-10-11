import requests
import settings
from models import vast as models
from lib.sys import log
import json
import os

api_key_path = settings.DIR + "/api_key"
api_key = None

if os.path.isfile(api_key_path):
    api_key_file = open(api_key_path, "r")
    api_key = api_key_file.read().strip()
    log("API Key Exists:", api_key)

class Vast:
    username: str
    password: str
    endpoint: str
    __cookies = None

    headers = {
        "Content-Type": "application/json",
    }

    @property
    def cookies(self):
        if not self.__cookies:
            try:
                with open(self.cookie_path, "r") as file:
                    data = file.read()
                    self.cookies = json.loads(data)
                    return self.__cookies
            except:
                log("No cookie file found")
        else:
            return self.__cookies

    @cookies.setter
    def cookies(self, cookies):
        self.__cookies = cookies
        requests.utils.add_dict_to_cookiejar(self.session.cookies, cookies)

        with open(self.cookie_path, "w+") as file:
            file.write(json.dumps(cookies))

    def __init__(self, username, password):
        self.endpoint = "https://vast.ai/api/v0"
        self.cookie_path = "data/cookies.json"
        self.username = username
        self.password = password
        self.session = requests.session()
        self.session.headers.update(self.headers)

        if api_key == None:
            self._authenticate()

    def _authenticate(self):
        log("Authenticating user:", self.username, "pass:", self.password)

        if self.cookies:
            if self.get_user():
                log("Session exists in cache")
                return
            else:
                log("Sesssion expired")

        data, response = self._post("/users/current/", {
            "username": self.username,
            "password": self.password,
        }, method="PUT")

        if response.status_code == 200:
            log("Succesfully logged in")
            self.user = models.User(**data)
            self.cookies = response.cookies.get_dict()
        else:
            log("Error authenticating user", response.status_code)

    def _build_url(self, path):
        if api_key == None:
            return self.endpoint + path
        else:
            return self.endpoint + path + "?api_key=" + api_key

    def _get(self, path):
        path = self._build_url(path)
        response = self.session.get(path)
        log("GET request to:", path)

        if response.status_code != 200:
            log("Error making GET request to:", path)
            return None, response

        return response.json(), response

    def _post(self, path, data, method="POST"):
        path = self._build_url(path)
        data = json.dumps(data)
        log(method, "request to:", path)

        if method == "POST":
            response = self.session.post(path, data=data)
        if method == "PUT":
            response = self.session.put(path, data=data)

        if response.status_code != 200:
            log("Error making " + method + " to:", path, "Response:", response.text)
            return None, response

        return response.json(), response

    def get_user(self):
        data, response = self._get("/users/current")
        self.user = models.User(**data)
        return self.user

    def get_account(self):
        data, response = self._get("/users/0/invoices/")

        if data == None:
            log("Failed to get account", response.status_code)
            return

        return models.Account(**data)

    def get_instances(self, machine_id):
        data, _ = self._get("/instances/")
        instances = []

        for item in data['instances']:
            if item['machine_id'] == machine_id:
                instances.append(models.Instance(**item))

        return instances

    def get_machine(self, id):
        data, response = self._get("/machines/")

        if response.status_code != 200:
            return log("Failed to get machine", response.text)

        for item in data['machines']:
            if item['id'] == id:
                return models.Machine(**item)

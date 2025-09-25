import requests
import random
import string

class JsonAPI():

    def get_random_users(self):
        response = requests.get("https://jsonplaceholder.typicode.com/users", verify=False)
        users = response.json()
        for i in (users) :
            i["birthday"] = self.get_random_bday()
            i["password"] = self.generate_passwd(8)
            i["address"]["state"] = i["address"]["suite"][:3]
        return users
    
    def get_random_bday(self):
        year = random.randint(1990, 2024)
        month = random.randint(1, 12)
        day = random.randint(1, 28)
        return f"{month:02d}{day:02d}{year:04d}"
    
    def generate_passwd(self,length):
        return ''.join(random.choice(string.ascii_letters + string.digits + "!@#$%") for _ in range(length))
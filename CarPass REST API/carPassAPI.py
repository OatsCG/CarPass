import os
import json
import random
from uuid import UUID

# generate cars if doesnt exist
script_dir = os.path.dirname(os.path.abspath(__file__))
storage_path = os.path.join(script_dir, 'storage', 'cars.json')

if os.path.exists(storage_path):
    print("File exists")
else:
    print("File does not exist, creating...")
    towrite = {
        "cars": [],
        "users": []
    }
    with open(storage_path, 'w') as file:
        file.write(json.dumps(towrite))

def get_data() -> dict:
    try:
        with open(storage_path, 'r') as file:
            file_content = file.read()
        json_data = json.loads(file_content)
        return json_data
    except Exception as e:
        print(f"Error: {e}")
        return None

hashbucket = []
characters = "ABCDEFGHKMNPQRSTUVWXYZ23456789"
def uuid4() -> str:
    rand = ''.join(random.choices(characters, k=4))
    if rand in hashbucket:
        return uuid4()
    else:
        hashbucket.append(rand)
        return rand


class CarPass:
    cars: list[dict]
    users: list[dict]
    
    def __init__(self):
        d = get_data()
        if d == None:
            print("Error getting data, killing.")
            quit()
        else:
            self.cars = d["cars"]
            self.users = d["users"]
            for car in self.cars:
                hashbucket.append(car["id"])
            for user in self.users:
                hashbucket.append(user["id"])
    
    def update_storage(self) -> bool:
        # returns true if successful
        try:
            towrite = {
                "cars": self.cars,
                "users": self.users
            }
            with open(storage_path, 'w') as file:
                file.write(json.dumps(towrite))
                return True
        except Exception as e:
            print(f"Error: {e}")
            return False

    def new_car(self, userID: UUID, name: str) -> UUID:
        user = self.get_user(userID)
        car = {
            "name": name,
            "id": str(uuid4()),
            "whohas": user["id"],
            "whohasusername": user["name"],
            "whohasusercolor": user["color"],
            "users": [user["id"]],
            "pendingInvites": [],
            "pendingRanges": [],
            "confirmedRanges": []
        }
        self.cars.append(car)
        user["car"] = car["id"]
        self.update_storage()
        return car["id"]
    
    def new_user(self, name: str) -> UUID:
        user = {
            "name": name,
            "id": str(uuid4()),
            "color": "blue", #red, orange, yellow, green, blue, indigo, violet
            "car": None
        }
        self.users.append(user)
        self.update_storage()
        self.new_car(user["id"], "Car 1")
        return user["id"]

    def get_car(self, uuid: UUID) -> dict | None:
        for car in self.cars:
            if car["id"] == uuid:
                return car
        return None
    
    def get_user(self, uuid: UUID) -> dict | None:
        for user in self.users:
            if user["id"] == uuid:
                return user
        return None
    
    def remove_from_car(self, carID: UUID, userID: UUID) -> bool:
        car = self.get_car(carID)
        if car == None:
            return False
        else:
            user = self.get_user(userID)
            if (user == None):
                return False
            else:
                car["users"].remove(userID)
                user["car"] = None
            self.update_storage()
    
    def invite_to_car(self, carID: UUID, userID: UUID) -> bool:
        car = self.get_car(carID)
        if car == None:
            return False
        else:
            car["pendingInvites"].append(userID)
            self.update_storage()
            return True
    
    def get_car_users(self, carID: UUID) -> dict | None:
        car = self.get_car(carID)
        if car == None:
            return None
        else:
            carusers = []
            for userid in car["users"]:
                user = self.get_user(userid)
                carusers.append({
                    "id": user["id"],
                    "name": user["name"],
                    "color": user["color"],
                    "confirmed": True
                })
            for invite in car["pendingInvites"]:
                user = self.get_user(invite)
                carusers.append({
                    "id": user["id"],
                    "name": user["name"],
                    "color": user["color"],
                    "confirmed": False
                })
            return({
                "users": carusers
            })
    
    def update_color(self, userID: UUID, color: str) -> bool:
        user = self.get_user(userID)
        if user == None:
            return False
        else:
            user["color"] = color
            self.update_timerange_profiles(user["car"], userID)
            self.update_whohascar_profiles(user["car"], userID)
            self.update_storage()
    
    def update_name(self, userID: UUID, name: str) -> bool:
        user = self.get_user(userID)
        if user == None:
            return False
        else:
            user["name"] = name
            self.update_timerange_profiles(user["car"], userID)
            self.update_whohascar_profiles(user["car"], userID)
            self.update_storage()

    def update_car_name(self, carID: UUID, name: str) -> bool:
        car = self.get_car(carID)
        if car == None:
            return False
        else:
            car["name"] = name
            self.update_storage()
    
    def i_have_car(self, carID: UUID, userID: UUID) -> bool:
        car = self.get_car(carID)
        user = self.get_user(userID)
        if car == None or user == None:
            return False
        else:
            car["whohas"] = userID
            car["whohasusername"] = user["name"]
            car["whohasusercolor"] = user["color"]
            self.update_storage()


    def check_invites(self, userID: UUID) -> dict | None:
        invitelist = []
        for car in self.cars:
            invites = car["pendingInvites"]
            if userID in invites:
                invitelist.append(car["id"])
        return {
            "invites": invitelist
        }

    def accept_invite(self, carID: UUID, userID: UUID) -> bool:
        car = self.get_car(carID)
        car["users"].append(userID)
        car["pendingInvites"].remove(userID)
        user = self.get_user(userID)
        user["car"] = carID
        self.update_storage()
        return True
    
    def dismiss_invite(self, carID: UUID, userID: UUID) -> bool:
        car = self.get_car(carID)
        car["pendingInvites"].remove(userID)
        self.update_storage()
        return True

    def new_timerange(self, carID: UUID, userID: UUID, startEpoch: int, endEpoch: int, reason: str) -> UUID | None:
        car = self.get_car(carID)
        if car == None:
            return None
        else:
            try:
                user = self.get_user(userID)
                range = {
                    "id": str(uuid4()),
                    "user": userID,
                    "username": user["name"],
                    "usercolor": user["color"],
                    "reason": reason,
                    "accepted": [],
                    "start": startEpoch,
                    "end": endEpoch
                }
                car["pendingRanges"].append(range)
                if len(range["accepted"]) == len(car["users"]) - 1:
                    self.confirm_timerange(carID, range["id"])
                self.update_storage()
                return range["id"]
            except:
                return None

    def confirm_timerange(self, carID: UUID, rangeID: UUID) -> bool:
        car = self.get_car(carID)
        if car == None:
            return False
        else:
            for range in car["pendingRanges"]:
                if range["id"] == rangeID:
                    try:
                        user = self.get_user(range["user"])
                        confirmedRange = {
                            "id": range["id"],
                            "user": range["user"],
                            "username": user["name"],
                            "usercolor": user["color"],
                            "reason": range["reason"],
                            "start": range["start"],
                            "end": range["end"]
                        }
                        car["confirmedRanges"].append(confirmedRange)
                        car["pendingRanges"].remove(range)
                        self.update_storage()
                        return True
                    except:
                        return False
            return False
    
    def accept_timerange(self, carID: UUID, userID: UUID, rangeID: UUID) -> bool:
        car = self.get_car(carID)
        if car == None:
            return False
        else:
            for range in car["pendingRanges"]:
                if range["id"] == rangeID:
                    range["accepted"].append(userID)
                    if len(range["accepted"]) == len(car["users"]) - 1:
                        return self.confirm_timerange(carID, rangeID)
                    self.update_storage()
                    return True
            return False

    def update_timerange_profiles(self, carID: UUID, userID: UUID) -> bool:
        car = self.get_car(carID)
        user = self.get_user(userID)
        if car == None or user == None:
            return False
        else:
            for range in car["pendingRanges"]:
                if range["user"] == userID:
                    range["username"] = user["name"]
                    range["usercolor"] = user["color"]
            for range in car["confirmedRanges"]:
                if range["user"] == userID:
                    range["username"] = user["name"]
                    range["usercolor"] = user["color"]
    
    def update_whohascar_profiles(self, carID: UUID, userID: UUID) -> bool:
        car = self.get_car(carID)
        user = self.get_user(userID)
        if car == None or user == None:
            return False
        else:
            if (car["whohas"] == userID):
                car["whohasusername"] = user["name"]
                car["whohasusercolor"] = user["color"]


if __name__ == "__main__":
    carPass = CarPass()
    meID = carPass.new_user("charlie")
    #bmwID = carPass.new_car(meID, "beemer")
    
    benID = carPass.new_user("ben")
    carPass.invite_to_car(carPass.get_user(benID)["car"], meID)
    carPass.accept_invite(carPass.get_user(benID)["car"], meID)

    # rangeID = carPass.new_timerange(bmwID, meID, 123, 456)

    # carPass.accept_timerange(bmwID, benID, rangeID)
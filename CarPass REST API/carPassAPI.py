import os
import json
import random
from uuid import UUID
import time
from datetime import datetime, timedelta
import json
import subprocess
from datetime import datetime, timezone

# generate cars if doesnt exist
script_dir = os.path.dirname(os.path.abspath(__file__))
storage_path = os.path.join(script_dir, 'storage', 'cars.json')

if os.path.exists(storage_path):
    print("File exists")
else:
    print("File does not exist, creating...")
    towrite = {
        "cars": [],
        "users": [],
        "APNs": {}
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
    APNs: dict
    
    def __init__(self):
        d = get_data()
        if d == None:
            print("Error getting data, killing.")
            quit()
        else:
            self.cars = d["cars"]
            self.users = d["users"]
            if "APNs" in d:
                self.APNs = d["APNs"]
            else:
                self.APNs = {}
                self.update_storage()
            for car in self.cars:
                hashbucket.append(car["id"])
            for user in self.users:
                hashbucket.append(user["id"])
    
    def update_storage(self) -> bool:
        # returns true if successful
        try:
            towrite = {
                "cars": self.cars,
                "users": self.users,
                "APNs": self.APNs
            }
            with open(storage_path, 'w') as file:
                file.write(json.dumps(towrite))
                return True
        except Exception as e:
            print(f"Error: {e}")
            return False

    def new_car(self, userID: UUID, name: str) -> UUID:
        user = self.get_user(userID)
        # remove user from their current car
        currentcar = self.get_car(user["car"])
        if currentcar != None:
            try:
                currentcar["users"].remove(userID)
            except:
                print("user wasnt in car?")

        car = {
            "name": name,
            "id": str(uuid4()),
            "whohas": user["id"],
            "whohasusername": user["name"],
            "whohasusercolor": user["color"],
            "users": [user["id"]],
            "pendingInvites": [],
            "pendingRanges": [],
            "confirmedRanges": [],
            "rejectedRanges": []
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
            return True
    
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
            return True
    
    def update_name(self, userID: UUID, name: str) -> bool:
        user = self.get_user(userID)
        if user == None:
            return False
        else:
            user["name"] = name
            self.update_timerange_profiles(user["car"], userID)
            self.update_whohascar_profiles(user["car"], userID)
            self.update_storage()
            return True

    def update_car_name(self, carID: UUID, name: str) -> bool:
        car = self.get_car(carID)
        if car == None:
            return False
        else:
            car["name"] = name
            self.update_storage()
            return True
    
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
            return True


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
                self.sendCarRequestNotification(range)
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
                        if len(car["users"]) > 1:
                            self.sendCarAcceptedNotification(range)
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
        
    def reject_timerange(self, carID: UUID, userID: UUID, rangeID: UUID) -> bool:
        car = self.get_car(carID)
        if car == None:
            return False
        else:
            for range in car["pendingRanges"]:
                if range["id"] == rangeID:
                    range["rejected"] = userID
                    if range["user"] != userID:
                        car["rejectedRanges"].append(range)
                    car["pendingRanges"].remove(range)
                    self.update_storage()
                    return True
            return False
        
    def remove_accepted_timerange(self, carID: UUID, rangeID: UUID) -> bool:
        car = self.get_car(carID)
        if car == None:
            return False
        else:
            for range in car["confirmedRanges"]:
                if range["id"] == rangeID:
                    range["rejected"] = range["user"]
                    range["accepted"] = []
                    car["rejectedRanges"].append(range)
                    car["confirmedRanges"].remove(range)
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
            return True
    
    def update_whohascar_profiles(self, carID: UUID, userID: UUID) -> bool:
        car = self.get_car(carID)
        user = self.get_user(userID)
        if car == None or user == None:
            return False
        else:
            if (car["whohas"] == userID):
                car["whohasusername"] = user["name"]
                car["whohasusercolor"] = user["color"]
                return True
            else:
                return False
    
    def registerAPN(self, userID: UUID, APN: str) -> bool:
        if userID not in self.APNs:
            self.APNs[userID] = APN
            self.update_storage()
            return True
        else:
            return False
    
    def getAPN(self, userID: UUID) -> str | None:
        if userID in self.APNs:
            return self.APNs[userID]
        else:
            return None
    
    
    # NOTIFICATIONS

    def sendCarRequestNotification(self, range: dict) -> bool:
        rangeuser = self.get_user(range["user"])
        users = self.get_car_users(rangeuser["car"])
        rangetext = epoch_to_string(range["start"])
        message = "wants the car"
        if rangetext != "":
            message += " " + rangetext
        if rangeuser["name"] == "":
            message = "Someone " + message
        else:
            message = rangeuser["name"] + " " + message
        for user in users["users"]:
            if user["id"] != range["user"]:
                self.sendPushPotification(user["id"], message)
        return True
    
    def sendCarAcceptedNotification(self, range: dict) -> bool:
        rangeuser = self.get_user(range["user"])
        self.sendPushPotification(rangeuser["id"], "Your car request was accepted!")
        return True
    
    def tryPassCarMorningNotification(self) -> bool: # 11AM
        # for all cars:
        cars: list[dict] = self.cars
        for car in cars:
            # for all confirmed ranges:
            confirmedRanges: list[dict] = car["confirmedRanges"]
            for range in confirmedRanges:
                # if range starts today:
                startepoch = range["start"]
                if is_epoch_today(startepoch):
                    # if rangeUser != carWhoHas:
                    if range["user"] != car["whohas"]:
                        # send message to carWhoHas "Pass the car to rangeUser today."
                        message = "Pass the car to " + range["username"] + " today."
                        self.sendPushPotification(car["whohas"], message)
        return True
    
    def tryPassCarAfternoonNotification(self) -> bool: # 1PM
        # for all cars:
        cars: list[dict] = self.cars
        print("got cars")
        for car in cars:
            print("in a car")
            # for all confirmed ranges:
            confirmedRanges: list[dict] = car["confirmedRanges"]
            for range in confirmedRanges:
                print("in a range")
                # if range starts today:
                startepoch = range["start"]
                if is_epoch_today(startepoch):
                    print("epoch is today")
                    # if rangeUser != carWhoHas:
                    if range["user"] != car["whohas"]:
                        print("ranger doesnt have car")
                        # send message to rangeUser "Have the car? Don’t forget to mark it in the CarPass app!"
                        self.sendPushPotification(range["user"], "Have the car? Don’t forget to mark it in the CarPass app!")
        print("out of thing")
        return True

    
    def sendPushPotification(self, userID, message) -> bool:
        token = self.getAPN(userID)
        badgeset = "1"
        command = ["node", "carPassAPN.js", "-t", token, "-m", message, "-b", badgeset]
        print(" ".join(command))
        print("NOTIF SENDING...")
        print(command)
        result = subprocess.run(command, capture_output=True, text=True)
        return True



# helper functions

def is_epoch_today(epoch_timestamp: int) -> bool:
    # Get today's date in UTC
    today = datetime.now(timezone.utc).date()
    
    # Get the date of the provided timestamp
    timestamp_date = datetime.fromtimestamp(epoch_timestamp, tz=timezone.utc).date()
    
    return today == timestamp_date

def epoch_to_string(epoch_time):
    current_time = time.time()
    target_time = datetime.fromtimestamp(epoch_time)
    current_date = datetime.fromtimestamp(current_time).date()
    target_date = target_time.date()
    
    delta = (target_date - current_date).days
    
    if delta < 0:
        return ""
    elif delta == 0:
        return "today"
    elif delta == 1:
        return "tomorrow"
    else:
        return f"in {delta} days"



if __name__ == "__main__":
    carPass = CarPass()
    meID = carPass.new_user("charlie")
    #bmwID = carPass.new_car(meID, "beemer")
    
    benID = carPass.new_user("ben")
    carPass.invite_to_car(carPass.get_user(benID)["car"], meID)
    carPass.accept_invite(carPass.get_user(benID)["car"], meID)

    # rangeID = carPass.new_timerange(bmwID, meID, 123, 456)

    # carPass.accept_timerange(bmwID, benID, rangeID)
import os
import json
from uuid import UUID, uuid4

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

    def new_car(self, name: str) -> UUID:
        car = {
            "name": name,
            "id": str(uuid4()),
            "users": [],
            "pendingInvites": [],
            "pendingRanges": [],
            "confirmedRanges": []
        }
        self.cars.append(car)
        self.update_storage()
        return car["id"]
    
    def new_user(self, name: str) -> UUID:
        user = {
            "name": name,
            "id": str(uuid4()),
            "car": []
        }
        self.users.append(user)
        self.update_storage()
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
    
    def invite_to_car(self, carID: UUID, userID: UUID) -> bool:
        car = self.get_car(carID)
        if car == None:
            return False
        else:
            car["pendingInvites"].append(userID)
            self.update_storage()


    def check_invites(self, userID: UUID) -> UUID | None:
        for car in self.cars:
            invites = car["pendingInvites"]
            if userID in invites:
                return car["id"]
        return None

    def accept_invite(self, carID: UUID, userID: UUID) -> bool:
        for car in self.cars:
            if car["id"] == carID:
                car["users"].append(userID)
                car["pendingInvites"].remove(userID)
                for user in self.users:
                    if user["id"] == userID:
                        user["car"] = carID
                        self.update_storage()
                        return True
        return False

    def new_timerange(self, carID: UUID, userID: UUID, startEpoch: int, endEpoch: int) -> UUID | None:
        car = self.get_car(carID)
        if car == None:
            return None
        else:
            try:
                range = {
                    "id": str(uuid4()),
                    "user": userID,
                    "reason": "smd",
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
                    confirmedRange = {
                        "id": range["id"],
                        "user": range["user"],
                        "reason": range["reason"],
                        "start": range["start"],
                        "end": range["end"]
                    }
                    car["confirmedRanges"].append(confirmedRange)
                    car["pendingRanges"].remove(range)
                    self.update_storage()
                    return True
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



if __name__ == "__main__":
    carPass = CarPass()
    bmwID = carPass.new_car("beemer")
    meID = carPass.new_user("charlie")
    
    carPass.set_car(bmwID, meID)
    benID = carPass.new_user("ben")
    carPass.set_car(bmwID, benID)

    rangeID = carPass.new_timerange(bmwID, meID, 123, 456)

    carPass.accept_timerange(bmwID, benID, rangeID)
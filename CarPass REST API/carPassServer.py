from flask import Flask, jsonify, request
from carPassAPI import CarPass

app = Flask(__name__)

carPass = CarPass()

# /carpassapi/newuser?name=String
@app.route('/carpassapi/newuser', methods=['GET'])
def get_data():
    name = request.args.get('name', default='username', type=str)
    user = carPass.new_user(name)
    data = {
        "uuid": user
    }
    return jsonify(data)

# /carpassapi/newcar?name=String
@app.route('/carpassapi/newcar', methods=['GET'])
def get_data():
    name = request.args.get('name', default='My Car', type=str)
    car = carPass.new_car(name)
    data = {
        "uuid": car
    }
    return jsonify(data)

# /carpassapi/getuser?id=UUID
@app.route('/carpassapi/getuser', methods=['GET'])
def get_data():
    id = request.args.get('id', default='', type=str)
    user = carPass.get_user(id)
    return jsonify(user)

# /carpassapi/getcar?id=UUID
@app.route('/carpassapi/getcar', methods=['GET'])
def get_data():
    id = request.args.get('id', default='', type=str)
    user = carPass.get_car(id)
    return jsonify(user)




if __name__ == '__main__':
    app.run(debug=True)
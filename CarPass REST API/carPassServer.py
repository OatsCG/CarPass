from flask import Flask, jsonify, request
from carPassAPI import CarPass

app = Flask(__name__)

carPass = CarPass()

# /carpassapi/newuser?name=String
@app.route('/carpassapi/newuser', methods=['GET'])
def newuser():
    name = request.args.get('name', default='username', type=str)
    user = carPass.new_user(name)
    return jsonify(user)

# /carpassapi/newcar?name=String
@app.route('/carpassapi/newcar', methods=['GET'])
def newcar():
    name = request.args.get('name', default='My Car', type=str)
    car = carPass.new_car(name)
    return jsonify(car)

# /carpassapi/getuser?id=UUID
@app.route('/carpassapi/getuser', methods=['GET'])
def getuser():
    id = request.args.get('id', default='', type=str)
    user = carPass.get_user(id)
    return jsonify(user)

# /carpassapi/getcar?id=UUID
@app.route('/carpassapi/getcar', methods=['GET'])
def getcar():
    id = request.args.get('id', default='', type=str)
    user = carPass.get_car(id)
    return jsonify(user)

# /carpassapi/acceptrange?carid=UUID&userid=UUID&rangeid=UUID   returns bool
@app.route('/carpassapi/acceptrange', methods=['GET'])
def acceptrange():
    carid = request.args.get('carid', default='', type=str)
    userid = request.args.get('userid', default='', type=str)
    rangeid = request.args.get('rangeid', default='', type=str)
    ret = carPass.accept_timerange(carid, userid, rangeid)
    return jsonify(ret)

# /carpassapi/acceptinvite?carid=UUID&userid=UUID   returns bool
@app.route('/carpassapi/acceptinvite', methods=['GET'])
def acceptinvite():
    carid = request.args.get('carid', default='', type=str)
    userid = request.args.get('userid', default='', type=str)
    invite = carPass.accept_invite(carid, userid)
    return jsonify(invite)

# /carpassapi/ihavecar?carid=UUID&userid=UUID   returns bool
@app.route('/carpassapi/ihavecar', methods=['GET'])
def ihavecar():
    carid = request.args.get('carid', default='', type=str)
    userid = request.args.get('userid', default='', type=str)
    ret = carPass.i_have_car(carid, userid)
    return jsonify(ret)

# /carpassapi/getusers?carid=UUID   returns dict
@app.route('/carpassapi/getusers', methods=['GET'])
def getusers():
    carid = request.args.get('carid', default='', type=str)
    ret = carPass.get_car_users(carid)
    return jsonify(ret)

# /carpassapi/updatecolor?userid=UUID&color=Color   returns bool
@app.route('/carpassapi/updatecolor', methods=['GET'])
def updatecolor():
    userid = request.args.get('userid', default='', type=str)
    color = request.args.get('color', default='', type=str)
    ret = carPass.update_color(userid, color)
    return jsonify(ret)



if __name__ == '__main__':
    app.run(host='192.168.2.231', port=5000, debug=True)
from flask import Flask, jsonify, request
from carPassAPI import CarPass
import time
from apscheduler.schedulers.background import BackgroundScheduler
import atexit
from datetime import datetime

app = Flask(__name__)

carPass = CarPass()

# /carpassapi/testserver
@app.route('/carpassapi/testserver', methods=['GET'])
def testserver():
    return jsonify(True)

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

# /carpassapi/sendrangerequest?carid=UUID&userid=UUID&start=int&end=int&reason=str   returns bool
@app.route('/carpassapi/sendrangerequest', methods=['GET'])
def sendrangerequest():
    carid = request.args.get('carid', default='', type=str)
    userid = request.args.get('userid', default='', type=str)
    start = request.args.get('start', default=0, type=int)
    end = request.args.get('end', default=1, type=int)
    reason = request.args.get('reason', default='', type=str)
    ret = carPass.new_timerange(carid, userid, start, end, reason)
    return jsonify(ret != None)

# /carpassapi/acceptrange?carid=UUID&userid=UUID&rangeid=UUID   returns bool
@app.route('/carpassapi/acceptrange', methods=['GET'])
def acceptrange():
    carid = request.args.get('carid', default='', type=str)
    userid = request.args.get('userid', default='', type=str)
    rangeid = request.args.get('rangeid', default='', type=str)
    ret = carPass.accept_timerange(carid, userid, rangeid)
    return jsonify(ret)

# /carpassapi/rejectrange?carid=UUID&userid=UUID&rangeid=UUID   returns bool
@app.route('/carpassapi/rejectrange', methods=['GET'])
def rejectrange():
    carid = request.args.get('carid', default='', type=str)
    userid = request.args.get('userid', default='', type=str)
    rangeid = request.args.get('rangeid', default='', type=str)
    ret = carPass.reject_timerange(carid, userid, rangeid)
    return jsonify(ret)

# /carpassapi/pendinvite?carid=UUID&userid=UUID   returns bool
@app.route('/carpassapi/pendinvite', methods=['GET'])
def pendinvite():
    carid = request.args.get('carid', default='', type=str)
    userid = request.args.get('userid', default='', type=str)
    invite = carPass.invite_to_car(carid, userid)
    return jsonify(invite)

# /carpassapi/acceptinvite?carid=UUID&userid=UUID   returns bool
@app.route('/carpassapi/acceptinvite', methods=['GET'])
def acceptinvite():
    carid = request.args.get('carid', default='', type=str)
    userid = request.args.get('userid', default='', type=str)
    invite = carPass.accept_invite(carid, userid)
    return jsonify(invite)

# /carpassapi/forceacceptinvite?carid=UUID&userid=UUID   returns bool
@app.route('/carpassapi/forceacceptinvite', methods=['GET'])
def forceacceptinvite():
    carid = request.args.get('carid', default='', type=str)
    userid = request.args.get('userid', default='', type=str)
    invite = carPass.invite_to_car(carid, userid)
    if (invite == True):
        inv = carPass.accept_invite(carid, userid)
        return jsonify(inv)
    else:
        return jsonify(False)

# /carpassapi/dismissinvite?carid=UUID&userid=UUID   returns bool
@app.route('/carpassapi/dismissinvite', methods=['GET'])
def dismissinvite():
    carid = request.args.get('carid', default='', type=str)
    userid = request.args.get('userid', default='', type=str)
    invite = carPass.dismiss_invite(carid, userid)
    return jsonify(invite)

# /carpassapi/checkinvites?userid=UUID   returns dict or None
@app.route('/carpassapi/checkinvites', methods=['GET'])
def checkinvites():
    userid = request.args.get('userid', default='', type=str)
    invites = carPass.check_invites(userid)
    return jsonify(invites)

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

# /carpassapi/updatename?userid=UUID&name=String   returns bool
@app.route('/carpassapi/updatename', methods=['GET'])
def updatename():
    userid = request.args.get('userid', default='', type=str)
    name = request.args.get('name', default='', type=str)
    ret = carPass.update_name(userid, name)
    return jsonify(ret)

# /carpassapi/updatecarname?carid=UUID&name=String   returns bool
@app.route('/carpassapi/updatecarname', methods=['GET'])
def updatecarname():
    carid = request.args.get('carid', default='', type=str)
    name = request.args.get('name', default='', type=str)
    ret = carPass.update_car_name(carid, name)
    return jsonify(ret)

# /carpassapi/newcarforme?userid=UUID   returns UUID
@app.route('/carpassapi/newcarforme', methods=['GET'])
def newcarforme():
    userid = request.args.get('userid', default='', type=str)
    car = carPass.new_car(userid, "Car 1")
    return jsonify(car)

# /carpassapi/revokerange?carid=UUID&rangeid=UUID   returns bool
@app.route('/carpassapi/revokerange', methods=['GET'])
def revokerange():
    carid = request.args.get('carid', default='', type=str)
    rangeid = request.args.get('rangeid', default='', type=str)
    ret = carPass.remove_accepted_timerange(carid, rangeid)
    return jsonify(ret)

# /carpassapi/registerapn?userid=UUID&apn=str   returns bool
@app.route('/carpassapi/registerapn', methods=['GET'])
def registerapn():
    userid = request.args.get('userid', default='', type=str)
    apn = request.args.get('apn', default='', type=str)
    ret = carPass.registerAPN(userid, apn)
    return jsonify(ret)

# /carpassapi/testnotif?id=UserID   returns bool
@app.route('/carpassapi/testnotif', methods=['GET'])
def testnotif():
    userid = request.args.get('userid', default='', type=str)
    ret = carPass.sendPushPotification(userid, "testing testing 123!")
    return jsonify(ret)


def scheduled_morning_task():
    print("This task runs every day at 11 AM. Current time:", datetime.now())
    carPass.tryPassCarMorningNotification()
    return

def scheduled_afternoon_task():
    print("This task runs every day at 1 PM. Current time:", datetime.now())
    carPass.tryPassCarAfternoonNotification()
    print("done notifications!")

scheduler = BackgroundScheduler()
scheduler.add_job(func=scheduled_morning_task, trigger="cron", hour=11, minute=0)
scheduler.add_job(func=scheduled_afternoon_task, trigger="cron", hour=13, minute=0)
scheduler.start()

# Shut down the scheduler when exiting the app
atexit.register(lambda: scheduler.shutdown())




if __name__ == '__main__':
    app.run(host='192.168.2.233', port=5000, debug=False)
    #app.run(host='192.168.2.18', port=5000, debug=False)
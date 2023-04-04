from flask import Flask, jsonify, request, redirect, url_for, session
from flask_session import Session
import cx_Oracle
import secrets


app = Flask(__name__)

secret_key = secrets.token_hex(16)


# Configure Flask-Session to use an Oracle database
# app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = 'oracle'
app.secret_key = secret_key.encode('utf-8')


# Connexion à la base de données Oracle

dsn = cx_Oracle.makedsn(host='localhost', port='1521',
                        sid='xe')  # for localhost oracle
# dsn = cx_Oracle.makedsn(host='20.55.44.15', port='1521', service_name='ORCLCDB.localdomain') # for remote oracle

# Route pour récupérer les données en format JSON


"""
This code connects to an Oracle database using cx_Oracle, stores the session object in Flask-Session, 
and returns a JSON response. If the request method is POST, it expects a JSON payload with username and password fields. 
If the connection is successful, it returns a 200 OK response with a status field set to 'success'. Otherwise, 
it returns a 401 Unauthorized response with a status field set to 'failed' and a message field with the error message. 
If the request method is not POST, 
it expects the user and pass parameters to be passed as query string parameters and returns them in a JSON payload.


remarque : 
    if i go to url directly in browser it use by default GET method exemple : 
        http:/20.55.44.15:5000/ => donner  JSON payload. with user and pass null
        http://20.55.44.15:5000/?user=hicham&pass=1234 =>  donner  JSON payload. with user = hicham and pass = 1234

    for post method :
        curl -X POST -H "Content-Type: application/json" -d '{"username":"super", "password":"1234"}' -c cookies.txt http://127.0.0.1:5000/

            => donner {"session id":"5ba6e8fd-88ad-456c-afe4-658cf954af72"}

        curl -X POST -H "Content-Type: application/json" -d '{"session_id": "5ba6e8fd-88ad-456c-afe4-658cf954af72"}' -b cookies.txt http://127.0.0.1:5000/test


"""


@app.route('/', methods=['POST', 'GET'])
def index():
    # récupération des données POST envoyées depuis l'application Android
    if request.method == 'POST':
        data = request.get_json()
        username = data['username']
        password = data['password']

        # connexion à la base de données Oracle
        try:
            conn = cx_Oracle.connect(user=username, password=password, dsn=dsn)

            # store the connection in Flask-Session
            # we cant stock the connection object in Flask-Session (conn)
            """
            session['oracle'] = {
                'username': username,
                'password': password,
                'dsn': dsn
            }
            """
            ses = secret_key.encode('utf-8')
            app.config["SESSION_ORACLE"] = {
                "session_id": ses,
                "username": username,
                "password": password,
                "dsn": dsn,
            }
            Session(app)
            # session['user'] = username
            # session['session_id'] = session.sid

            # session.modified = True

            # si la connexion est réussie, retourner une réponse 200 OK

            # session_id = session.sid
            sev = ses.decode('utf-8')
            return jsonify({'session_id': sev}), 200

        except cx_Oracle.DatabaseError as e:
            # si la connexion est échouée, retourner une réponse 401 Unauthorized
            return jsonify({'status': 'failed', 'message': str(e)}), 401
    else:
        user = request.args.get('user')
        password = request.args.get('pass')
        data = [{'user': user, 'passw': password}]
        return jsonify(data)


@app.route('/materiel', methods=['POST', 'GET'])
def get_data_mat():
    if request.method == 'POST':
        data = request.get_json()
        session_id = data['session_id']
        if 'session_id' in session and session_id == session['session_id']:
            # Retrieve the session variables
            connval = session.get('oracle')

            conn = cx_Oracle.connect(
                user=connval['username'], password=connval['password'], dsn=connval['dsn'])
            if not conn:
                return redirect(url_for('info'))

            cursor = conn.cursor()
            cursor.execute('SELECT * FROM materiel')
            result = cursor.fetchall()

            # Transformation des données en format JSON
            data = []
            for row in result:
                data.append({
                    'ID_MAT': row[0],
                    'NOMM': row[1],
                    'TYPE': row[2],
                    'ETATD': row[2],
                    'ETATM': row[2]
                })
            return jsonify(data)
        else:
            return redirect('/info')
    else:
        return 'OK'


@app.route('/projet', methods=['POST', 'GET'])
def get_data_proj():
    if request.method == 'POST':
        data = request.get_json()
        array1 = data[0]
        session_id = array1['session_id'].encode('utf-8')
        """
        found_sessions = []
        print (session.items())
        for key, value in session.items():
            if 'session_id' in value and value['session_id'] == session_id:
                found_sessions.append(key)
        """

        if session_id and session_id == app.config["SESSION_ORACLE"].get('session_id'):
            print('ok')
            connval = app.config["SESSION_ORACLE"]
            conn = cx_Oracle.connect(
                user=connval.get('username'), password=connval.get('password'), dsn=connval.get('dsn'))
            if not conn:
                return redirect(url_for('info'))
            cursor = conn.cursor()
            cursor.execute('SELECT * FROM PROJET')
            result = cursor.fetchall()
            print (result)
            # Transformation des données en format JSON
            data = []
            for row in result:
                data.append({
                    'IDPROJ': row[0],
                    'NOMPROJ': row[1],
                    'DATEDEB': row[2],
                    'DESCRIPTION': row[3],
                    'PN': row[4],
                    'ETATPROJ': row[5]
                })
            return jsonify(data)
        else:
            return redirect('/info')
    else:
        return 'OK'


@app.route('/info', methods=['POST', 'GET'])
def get_data_info():
    if request.method == 'POST':
        data = request.get_json()
        session_id = data['session_id'].encode('utf-8')
        if 'session_id' in session and session_id == session['session_id']:
            username = session.get('user')
            connval = session.get('oracle')
            conn = cx_Oracle.connect(
                user=connval['username'], password=connval['password'], dsn=connval['dsn'])

            if not username or not conn:
                return 'Connexion à Flask is running'

            cursor = conn.cursor()
            cursor.execute('SELECT * FROM PERSONNE where PN = ' + username)
            result = cursor.fetchall()

            data = [{

                'PN': result[0],
                'NOMP': result[1],
                'PRENOM': result[2],
                'EMAIL': result[3],
                'DATEEMB': result[4],
                'TITRE': result[5],  # fonctionalité de l'employé
                'ETATP': result[6],
                'NDEP': result[7],
                'ischef': result[8]  # 1 si chef de projet, 0 sinon
            }]
            return jsonify(data)
        else:
            return jsonify({'session id': 'session id not found'}), 401
    else:
        return 'OK'


@app.route('/test', methods=['POST', 'GET'])
def test():
    # check if session id from post is exist in flask session id stocked in server memory

    if request.method == 'POST':
        data = request.get_json()
        session_id = data['session_id']
        if 'session_id' in session and session_id == session['session_id']:
            return jsonify({'session id': session_id, 'user': session['user']}), 200
        else:
            return jsonify({'session id': 'session id not found'}), 401
    else:
        # return session id from get request
        return 'ok'


@app.route('/deconnection', methods=['POST', 'GET'])
def decon():
    if request.method == 'POST':
        data = request.get_json()
        session_id = data['session_id']
        if 'session_id' in session and session_id == session['session_id']:
            session.clear()
            return jsonify({'session id': session_id, 'user': session['user']}), 200
        else:
            return jsonify({'session id': 'session id not found'}), 401
    else:
        return 'OK'


if __name__ == '__main__':
    # app.run(debug=True)
    # or app.run(host='0.0.0.0', port=5000, debug=True)
    app.run(host='0.0.0.0', port=5000, debug=True)

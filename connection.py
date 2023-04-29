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
            
            # fonction de verification si l'utilisateur est un chef ou non

            cursor = conn.cursor()
            cursor.execute("SELECT dev.FUNCISCHEF() FROM dual")
            result = cursor.fetchone()[0]
            print(result)
            # Fermer le curseur et la connexion
            # cursor.close()
        
            sev = ses.decode('utf-8')
            return jsonify({'session_id': sev,"ischef": result}), 200

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

            conn = cx_Oracle.connect(user=connval['username'], password=connval['password'], dsn=connval['dsn'])
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
            print(result)
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

@app.route("/affichertachechef", methods=["POST", "GET"])
def get_task_poject():
    if request.method == "POST":
        data = request.get_json()
        array1 = data[0]
        session_id = array1["session_id"].encode("utf-8")
        id_projet2 = array1["idproj"]

        if session_id and session_id == app.config["SESSION_ORACLE"].get("session_id"):
            connval = app.config["SESSION_ORACLE"]
            print("ok")
            # conn = cx_Oracle.connect(
            #   user=connval.get('username'), password=connval.get('password'), dsn=connval.get('dsn'))
            conn = cx_Oracle.connect(
                connval.get("username")
                + "/"
                + connval.get("password")
                + "@localhost:1521/XEPDB1"
            )
            if not conn:
                return redirect(url_for("info"))
            print(id_projet2)
            # id_projet2 = 1
            cursor = conn.cursor()
            cursor.execute(
                "SELECT * FROM dev.AFFICHERTACHEPROJETCHEF WHERE IDPROJ = :id_projet",
                {"id_projet": id_projet2},
            )

            result = cursor.fetchall()

            # Transformation des données en format JSON
            data = []
            for row in result:
                data.append(
                    {
                        "IDTACHE": row[0],
                        "DATE_CREATION": row[1],
                        "DATE_ECHEANCE": row[2],
                        "DUREE_ESTIMEE": row[3],
                        "ETATT": row[4],
                        "DECRIPTION": row[5],
                        "SCORE": row[6],
                        "IDPROJ": row[7],
                        "NOMEMP": row[8],
                    }
                )
            print(data)
            return jsonify(data)
        else:
            return redirect("/info")
    else:
        return "OK"


@app.route('/afficherGraph1', methods=['POST', 'GET'])
def get_data_graph():
    if request.method == 'POST':
        data = request.get_json()
        array1 = data[0]
        query = data[0]['query']
        session_id = array1['session_id'].encode('utf-8')

        if session_id and session_id == app.config["SESSION_ORACLE"].get('session_id'):
            connval = app.config["SESSION_ORACLE"]
            print('ok')
            # conn = cx_Oracle.connect(
            #   user=connval.get('username'), password=connval.get('password'), dsn=connval.get('dsn'))
            conn = cx_Oracle.connect(
                connval.get('username') + '/' + connval.get('password') + '@localhost:1521/XEPDB1')

            if not conn:
                return redirect(url_for('info'))

            if query == 'difference':
                cursor = conn.cursor()
                cursor.execute('select * from dev.afficherdiffrenceEntredate')
                result = cursor.fetchall()
            elif query == 'score':
                cursor = conn.cursor()
                cursor.execute('select * from dev.afficherScore')
                result = cursor.fetchall()
            else:
                return 'Invalid query'

            print(result)

            # Transformation des données en format JSON
            data = []
            for row in result:
                data.append({
                    'nomemp': row[0],
                    'score': row[1]
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



@app.route('/getTaches',methods=['POST', 'GET'])
def get_taches():
    # establish a connection to the database

    if request.method == 'POST':
        data = request.get_json()
        username = data['username']
        password = data['password']

        try:
            conn = cx_Oracle.connect(user=username, password=password, dsn=dsn)


            cursor = conn.cursor()

            # execute a SELECT statement to retrieve tasks from the TACHE table
            cursor.execute('SELECT * FROM TACHE')

            # create a list of tasks from the query results
            tasks = []
            for row in cursor:
                task = {
                    'id': row[0],
                    'date_creation': str(row[1]),
                    'date_echeance': str(row[2]),
                    'duree_estimee': str(row[3]),
                    'etat': row[4],
                    'description': row[5],
                    'score': row[6],
                    'id_projet': row[7],
                    'pn': row[8]
                }
                tasks.append(task)

            # close the cursor and the database connection
            cursor.close()
            conn.close()

            # return the list of tasks as a JSON response
            return jsonify({'status': 'success', 'taches': tasks})
        except cx_Oracle.DatabaseError as e:
            return jsonify({'status': 'error', 'message': 'Database error: ' + str(e)})
    else:
        return 'OK'


@app.route("/ratetache", methods=["POST", "GET"])
def ratetache():
    if request.method == "POST":
        data = request.get_json()
        session_id = data["session_id"].encode("utf-8")
        id_tache = data["id_tache"]
        scoreval = data["scoreval"]

        if session_id and session_id == app.config["SESSION_ORACLE"].get("session_id"):
            connval = app.config["SESSION_ORACLE"]
            print("ok")
            # conn = cx_Oracle.connect(
            #   user=connval.get('username'), password=connval.get('password'), dsn=connval.get('dsn'))
            conn = cx_Oracle.connect(
                connval.get("username")
                + "/"
                + connval.get("password")
                + "@localhost:1521/XEPDB1"
            )

            if not conn:
                return redirect(url_for("info"))

            cursor = conn.cursor()
            cursor.callproc("dev.rateTache", [id_tache, scoreval])

            # enregistrer les changements dans la base de données
            conn.commit()
            return jsonify({"etat": "ok"}), 200
        else:
            return redirect("/info")
    else:
        return "OK"



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

from flask import Flask, jsonify, request, redirect, url_for, session
from flask_session import Session
import cx_Oracle

app = Flask(__name__)

# Configure Flask-Session to use an Oracle database
app.config['SESSION_TYPE'] = 'oracle'

# Connexion à la base de données Oracle

# dsn = cx_Oracle.makedsn(host='localhost', port='1521', sid='xe')
# dsn = cx_Oracle.makedsn(host='20.55.44.15', port='1521', service_name='ORCLCDB.localdomain')

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
            dsn = cx_Oracle.makedsn(host='localhost', port='1521', sid='xe')
            session = cx_Oracle.connect(user=username, password=password, dsn=dsn)
            # store the session in Flask-Session
            session['oracle'] = cx_Oracle.connect(user=username, password=password, dsn=dsn)
            session['user'] = username
            Session(app) # Initialize the session

            # si la connexion est réussie, retourner une réponse 200 OK
            return jsonify({'status': 'success'}), 200
        except cx_Oracle.DatabaseError as e:
            # si la connexion est échouée, retourner une réponse 401 Unauthorized
            return jsonify({'status': 'failed', 'message': str(e)}), 401
    else:
        user = request.args.get('user')
        password = request.args.get('pass')
        data = [{'user': user, 'passw': password}]
        return jsonify(data)

@app.route('/materiel')
def get_data():
    # Retrieve the session variables
    username = session.get('user')
    conn = session.get('oracle')
    if not username or not conn:
        return redirect(url_for('test'))

    cursor = conn.cursor()
    cursor.execute('SELECT * FROM materiel')
    result = cursor.fetchall()

    # Transformation des données en format JSON
    data = []
    for row in result:
        data.append({
            'id': row[0],
            'nom': row[1],
            'prenom': row[2]
        })
    return jsonify(data)

@app.route('/test')
def test():
    username = session.get('user')
    conn = session.get('oracle')

    if not username or not conn:
        return 'Connexion à Flask is running'

    else:
        data = [{'user': username}]
        return jsonify(data)




"""
if __name__ == '__main__':
    # app.run(debug=True)
    # or app.run(host='0.0.0.0', port=5000, debug=True)
    app.run(host='0.0.0.0.0', port=5000, debug=True, threaded=False)
"""
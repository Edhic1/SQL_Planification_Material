from flask import Flask, jsonify, request
import cx_Oracle

app = Flask(__name__)
# Connexion à la base de données Oracle

# Route pour récupérer les données en format JSON


@app.route('/materiel')
def get_data():
   # data = request.get_json()
    username = 'system'
    password = '2002****'
    conn = cx_Oracle.connect(
        'system/2002****@192.168.42.122:1521/XEPDB1')
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

    cursor.close()  # Fermeture du curseur
    conn.close()  # Fermeture de la connexion
    return jsonify(data)


@app.route('/materiel1', methods=['POST'])
def get_data1():
    data = request.get_json()
    username = data['username']
    password = data['password']
    conn = cx_Oracle.connect(
        username + '/' + password + '@192.168.42.122:1521/XEPDB1')
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM system.materiel')
    result = cursor.fetchall()

    # Transformation des données en format JSON
    data = []
    for row in result:
        data.append({
            'id': row[0],
            'nom': row[1],
            'prenom': row[2]
        })

    # cursor.close()  # Fermeture du curseur
    # conn.close()  # Fermeture de la connexion
    return jsonify(data)


@app.route('/authentification', methods=['GET', 'POST'])
def authentification():
    # récupération des données POST envoyées depuis l'application Android
    if request.method == 'POST':
        data = request.get_json()
        username = data['username']
        password = data['password']

        # connexion à la base de données Oracle
        try:
            conn = cx_Oracle.connect(
                username + '/' + password + '@192.168.42.122:1521/XEPDB1')
            # si la connexion est réussie, retourner une réponse 200 OK
            return jsonify({'status': 'success'}), 200
            conn.close()
        except cx_Oracle.DatabaseError as e:
            # si la connexion est échouée, retourner une réponse 401 Unauthorized
            return jsonify({'status': 'failed', 'message': str(e)}), 401
    else:
        data = []
        user = request.args.get('user')
        passw = request.args.get('pass')
        data = [{
            'user': user,
            'passw': passw
        }]
        return jsonify(data)


if __name__ == '__main__':
    # app.run(debug=True)
    app.run(host='192.168.42.122', port=5000, debug=True, threaded=False)

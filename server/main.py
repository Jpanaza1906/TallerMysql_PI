from flask import Flask, request, jsonify
import mysql.connector
import csv

app = Flask(__name__)

db_config = {
        'host': 'localhost',
        'user': 'root',
        'password': 'mysql123',
        'database': 'taller_mysql'
}

@app.route('/cargarmodelo', methods=['GET'])
def cargar_modelo():
    # Establecer la conexión a la base de datos MySQL
    connection = mysql.connector.connect(**db_config)

    # Crear un cursor para ejecutar consultas
    cursor = connection.cursor(dictionary=True)

    with open('archivos/paises.csv', newline ='') as csv_file:
        reader = csv.reader(csv_file)

        #variable
        x= 0
        carga_pais = ''

        for row in reader:
            data = row[0].split(';')
            if x == 0:
                cabera_pais = "INSERT INTO pais (id_pais, nombre_pais)"
                x=x+1
            else:
                carga_pais = cabera_pais
                carga_pais += "VALUES ('"+data[0]+"','"+data[1]+"')"
                cursor.execute(carga_pais)
            
        connection.commit()

    cursor.close()
    connection.close()

    return jsonify({"Accion": "Datos cargados"})


if __name__ == '__main__':
    app.run(debug=True)


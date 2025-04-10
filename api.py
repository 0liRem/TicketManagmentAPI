'''Documentation


Author: Olivier Viau

Resources: Flask, FlaskAlchemy, datetime, click,DeepSeek (Para consultar recursos y dudas sobre errores de inicialización y para la transcripción del archivo .txt para el .md)

Date
[000]  27/3/2025
[001]

Config y models: La existencia de estos 2 archivos es con el fin de manejar un codigo limpio, al tener la conexión a la base de datos y el modelo de la base hace que se requieran menos 
funciones en la API y se mantenga limpio el codigo.
'''


from flask import Flask, request, jsonify
from models import db, Incident
from flask_cors import CORS
from config import Config
from datetime import datetime
import click
app = Flask(__name__)
app.config.from_object(Config)
CORS(app)
db.init_app(app)

#Estados permitidos
ALLOWED_STATUSES = ['pendiente', 'resuelto']

@app.route('/incidents', methods=['POST'])
def create_incident():
    data = request.get_json()
    #Revisa que se este enviando el usuario y la descripción con un minimo de 10 caracteres
    if not data.get('reporter'):
        return jsonify({'error': 'El campo reporter es obligatorio'}), 400
    
    if not data.get('description') or len(data.get('description', '')) < 10:
        return jsonify({'error': 'La descripción debe tener al menos 10 caracteres'}), 400
    
    # Nuevo incidente
    new_incident = Incident(
        reporter=data['reporter'],
        description=data['description'],
        status=data.get('status', 'pendiente')
    )
    #enviar datos a la base de datos
    db.session.add(new_incident)
    db.session.commit()
    
    return jsonify(new_incident.to_dict()), 201
#Get para enviar incidentes
@app.route('/incidents', methods=['GET'])
def get_incidents():
    incidents = Incident.query.all() #obtiene datos de la base
    return jsonify([incident.to_dict() for incident in incidents]) #vuelve un json los datos

@app.route('/incidents/<int:id>', methods=['GET']) #obtiene los incidentes por ID
def get_incident(id):
    incident = Incident.query.get(id)
    if not incident:
        return jsonify({'error': 'Incidente no encontrado'}), 404 #Si no existe da error
    return jsonify(incident.to_dict())

@app.route('/incidents/<int:id>', methods=['PUT']) #cambia los estados con estee metodo
def update_incident(id):
    incident = Incident.query.get(id)
    if not incident:
        return jsonify({'error': 'Incidente no encontrado'}), 404
    
    data = request.get_json()
    
    # Validación para solo cambiar el estatus y no poder alterar nada más
    if 'status' not in data:
        return jsonify({'error': 'Solo se puede actualizar el status'}), 400
    
    if data['status'] not in ALLOWED_STATUSES:
        return jsonify({'error': f'Status no válido. Los valores permitidos son: {", ".join(ALLOWED_STATUSES)}'}), 400
    
    incident.status = data['status']
    db.session.commit()
    
    return jsonify(incident.to_dict())

@app.route('/incidents/<int:id>', methods=['DELETE']) #Metodo Delete
def delete_incident(id):
    incident = Incident.query.get(id)
    if not incident: #Si no existee no hace nada
        return jsonify({'error': 'Incidente no encontrado'}), 404
    #Si existe borra el incidente de la base de datos
    db.session.delete(incident)
    db.session.commit()
    #Regresa un Json que dice que el incidente se elimino
    return jsonify({'message': 'Incidente eliminado correctamente'}), 200

@app.cli.command("create-db")#Crea las tablas
def create_tables():
    db.create_all()

#Inicializador
if __name__ == '__main__':
    app.run(debug=True)
document.addEventListener('DOMContentLoaded', () => {
    const incidentForm = document.getElementById('incidentForm');
    const searchBtn = document.getElementById('searchBtn');
    const refreshBtn = document.getElementById('refreshBtn');
    const updateBtn = document.getElementById('updateBtn');
    const deleteBtn = document.getElementById('deleteBtn');
    const incidentDetails = document.getElementById('incidentDetails');
    const incidentsList = document.getElementById('incidentsList');
    
    // API
    const API_URL = 'http://127.0.0.1:5000/incidents';
    
    cargar();
    

    incidentForm.addEventListener('submit', Enviar);
    searchBtn.addEventListener('click', Buscar);
    refreshBtn.addEventListener('click', cargar);
    updateBtn.addEventListener('click', Actualizar);
    deleteBtn.addEventListener('click', Borrar);
    
    // Enviar formulario
    async function Enviar(e) {
        e.preventDefault();
        
        const reporter = document.getElementById('reporter').value;
        const description = document.getElementById('description').value;
        
        try { //Prueba hacer el metodo post
            const response = await fetch(API_URL, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    reporter,
                    description,
                    status: 'pendiente'
                })
            });
            
            if (!response.ok) {// Si no obtiene respuesta de la API
                const errorData = await response.json();
                throw new Error(errorData.error || 'Error al crear el incidente');
            }
            
            const newIncident = await response.json();
            alert(`Incidente creado con ID: ${newIncident.id}`);
            incidentForm.reset();
            cargar();
        } catch (error) {//Da error si no puede
            alert(error.message);
        }
    }
    
    // Busqueda por ID, no dinamica
    async function Buscar() {
        const id = document.getElementById('searchId').value;
        
        if (!id) {
            alert('Por favor ingrese un ID válido');
            return;
        }
        
        try {
            const response = await fetch(`${API_URL}/${id}`);
            
            if (!response.ok) {
                if (response.status === 404) {
                    throw new Error('Incidente no encontrado');
                }
                throw new Error('Error al buscar el incidente');
            }
            
            const incident = await response.json();
            displayIncidentDetails(incident);
        } catch (error) {
            alert(error.message);
            incidentDetails.classList.add('hidden');
        }
    }
    
    // Al buscar un incidente por ID muestra los detalles permitiendo cambiar el incidente o eliminarlo
    function displayIncidentDetails(incident) {
        document.getElementById('detail-id').textContent = incident.id;
        document.getElementById('detail-reporter').textContent = incident.reporter;
        document.getElementById('detail-description').textContent = incident.description;
        document.getElementById('detail-status').value = incident.status;
        document.getElementById('detail-date').textContent = new Date(incident.created_at).toLocaleString();
        
        incidentDetails.classList.remove('hidden');
    }
    
    
    async function Actualizar() {
        const id = document.getElementById('detail-id').textContent;
        const status = document.getElementById('detail-status').value;
        
        try {
            const response = await fetch(`${API_URL}/${id}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ status })
            });
            
            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.error || 'Error al actualizar el incidente');
            }
            
            const updatedIncident = await response.json();
            displayIncidentDetails(updatedIncident);
            cargar();
            alert('Estado del incidente actualizado correctamente');
        } catch (error) {
            alert(error.message);
        }
    }
    
    async function Borrar() {
        const id = document.getElementById('detail-id').textContent;
        
        if (!confirm('¿Está seguro que desea eliminar este incidente?')) {
            return;
        }
        
        try {
            const response = await fetch(`${API_URL}/${id}`, {
                method: 'DELETE'
            });
            
            if (!response.ok) {
                throw new Error('Error al eliminar el incidente');
            }
            
            alert('Incidente eliminado correctamente');
            incidentDetails.classList.add('hidden');
            document.getElementById('searchId').value = '';
            cargar();
        } catch (error) {
            alert(error.message);
        }
    }
    

    async function cargar() {
        try {
            const response = await fetch(API_URL);
            
            if (!response.ok) {
                throw new Error('Error al cargar los incidentes');
            }
            
            const incidents = await response.json();
            displayAllIncidents(incidents);
        } catch (error) {
            alert(error.message);
        }
    }
    

    function displayAllIncidents(incidents) {
        incidentsList.innerHTML = '';
        
        if (incidents.length === 0) {
            incidentsList.innerHTML = '<p>No hay incidentes reportados.</p>';
            return;
        }
        
        incidents.forEach(incident => {
            const incidentCard = document.createElement('div');
            incidentCard.className = `incident-card ${incident.status}`;
            
            const date = new Date(incident.created_at).toLocaleString();
            
            incidentCard.innerHTML = `
                <h3>Incidente #${incident.id}</h3>
                <div class="incident-meta">
                    <strong>Reportado por:</strong> ${incident.reporter} | 
                    <strong>Estado:</strong> ${incident.status} | 
                    <strong>Fecha:</strong> ${date}
                </div>
                <p>${incident.description}</p>
            `;
            
            incidentsList.appendChild(incidentCard);
        });
    }
});
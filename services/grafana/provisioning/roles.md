## Roles y Permisos - Grafana

### 🧑‍🤝‍🧑 Equipos y Usuarios

| Equipo                   | Usuarios     | Permisos |
|---------------------------|--------------|-----------|
| Cúpula Directiva          | ceo user     | View      |
| Departamento de Análisis  | analist1     | View      |
| Departamento IT           | it_admin     | Edit      |

---

### 📊 Estructura de Dashboards

- **Data-Real-Time-Pandas:**  
  Dashboard técnico que muestra datos en tiempo real obtenidos mediante Python (API OpenWeather → InfluxDB).  
  Incluye **alertas configuradas para la ciudad de Granada** cuando la temperatura supera los **20 °C**.  
  Accesos:  
  - Cúpula Directiva → solo lectura  
  - Departamento de Análisis → visualización  
  - Departamento IT → edición y gestión de alertas  

- **Data-Real-Time-Node-RED:**  
  Dashboard que muestra los datos generados desde Node-RED y enviados a InfluxDB.  
  Incluye **alerta configurada cuando las temperaturas de las ciudades (Madrid, Sevilla, Bilbao o Barcelona) superan los 29 °C**.  
  Accesos:  
  - Cúpula Directiva → solo lectura  
  - Departamento de Análisis → visualización  
  - Departamento IT → edición y gestión de alertas  

---

### ⚙️ Configuración

- Los equipos se crearon desde: `Configuration → Teams`
- Los permisos se aplicaron en cada dashboard desde: `Share → Permissions`
- Las alertas se configuraron desde: `Alerting → Alert rules`
  - “Temperatura - Granada” → Dashboard **Data-Real-Time-Pandas**
  - “Temperaturas - 4 Ciudades” → Dashboard **Data-Real-Time-Node-RED**

---

✅ **Resumen final:**
- Total de Dashboards: 2  
- Total de alertas configuradas: 2  
- Permisos verificados y funcionales para cada equipo.

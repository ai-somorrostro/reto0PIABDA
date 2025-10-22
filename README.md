# Reto 0 - PIABDA

Este proyecto implementa una plataforma de **monitorización de datos meteorológicos en tiempo real** utilizando tecnologías de Big Data y automatización: **InfluxDB**, **Grafana**, **Node-RED**, **Python** y **Docker Compose**.

Su objetivo es desplegar de forma automatizada una infraestructura completa que recupere, procese, almacene y visualice datos meteorológicos desde diferentes fuentes, facilitando su análisis en tiempo real a través de dashboards y alertas.

---

## Requisitos del sistema

- Sistema operativo: Linux (recomendado Ubuntu 22.04)
- Docker Engine >= 20.10
- Docker Compose >= 2.0
- Git
- Visual Studio Code (opcional)

---

## Estructura del Proyecto

```bash
.
├── services/                        # Servicios principales del sistema
│   ├── grafana/                     # Configuración y dashboards de Grafana
│   │   └── provisioning/
│   │       ├── dashboards/          # Dashboards importados automáticamente
│   │       ├── alerting/            # Reglas de alertas configuradas
│   │       ├── grafana_dashboards.yaml
│   │       └── grafana_alerts.yaml
│   ├── node-red/                    # Flujos y configuración de Node-RED
│   │   ├── data/flows/
│   │   │   └── flujo_reto.json
│   │   └── set_token.sh
│   └── python-scripts/              # Scripts de ingesta y generación de datos
│       └── weather_current.py
│
├── scripts/                         # Scripts de utilidad y automatización
│   ├── start_all.sh
│   ├── clean_all.sh
│   └── init-influxdb.sh
│
├── docs/                            # Documentación y archivos complementarios
│   ├── infraestructura.drawio
│   ├── roles.txt
│   └── capturas/
│
├── logs/                            # Logs de ejecución
│   └── weather_granada.log
│
├── docker-compose.yml               # Orquestador de servicios Docker
├── .env.example                     # Variables de entorno necesarias
├── requirements.txt                 # Dependencias de Python
└── README.md                        # Este archivo
```

## Cómo ejecutar el proyecto 
1. Clonar el repositorio
```bash
git clone https://github.com/usuario/proyecto-piabda.git
cd proyecto-piabda
```
2. Configurar variables de entorno

```bash
cp .env.example .env
Editar el archivo .env para añadir credenciales necesarias
```
3. Iniciar todos los servicios

```bash
cd automation
./start_all.sh
```

Esto lanzará automáticamente:
```bash
- InfluxDB

- Grafana

- Node-RED

- Script de Python

- Carga de dashboards y alertas

- Token compartido
```

## Acceso a servicios
```bash
Servicio      URL                     Usuario/Contraseña
---------     ---------------------   ----------------------------------------
InfluxDB      http://localhost:8086   ${INFLUXDB_USERNAME} / ${INFLUXDB_PASSWORD}
Grafana       http://localhost:3000   ${GRAFANA_USER} / ${GRAFANA_PASSWORD}
Node-RED      http://localhost:1880   No requiere login por defecto
```
## Buckets en InfluxDB

```bash
Bucket          Fuente           Measurement               Campos principales                                Tags
-------------   --------------   ------------------------  -------------------------------------------------  ------------
RETO0-Data      Node-RED         weather-realtime          temperatura, humedad, presion, etc.               tag_ciudad
RETO0-PANDAS    Python (Pandas)  weather-realtime-pandas   temperatura, humedad, viento_velocidad, etc.      ciudad
```

## Alertas configuradas

- Dashboard Node-RED: alerta si cualquier ciudad supera los 29 °C.

- Dashboard Python: alerta si Granada supera los 20 °C.


## Equipos y permisos en Grafana
```bash
Equipo                  Permisos
----------------------  --------------------------------------------
Cúpula Directiva        Solo visualización
Departamento Análisis   Visualización de dashboards
Departamento IT         Gestión total, edición, alertas
```

## Flujo de Datos
```bash
1. Node-RED obtiene datos de 4 ciudades cada 10 s
→ transforma datos
→ los envía a InfluxDB
→ se visualizan en Grafana

2. Script Python obtiene datos de Granada
→ los envía a InfluxDB
→ se visualizan en Grafana
```

## Cómo ejecutar el script Python manualmente

```bash
# Estar en la raíz del repositorio

# Asegúrate de tener el archivo .env configurado correctamente

# Ejecutar el script:
python pia/scripts_python/weather_current.py
```

## Cómo limpiar el entorno

```bash
cd automation
./clean_all.sh
```

## Entorno de ejecución

Este proyecto está diseñado para ejecutarse sobre una máquina virtual Ubuntu 22.04, con administración y edición desde VS Code.

Los contenedores Docker gestionan todos los servicios necesarios (InfluxDB, Grafana, Node-RED y Python), garantizando un despliegue reproducible en cualquier entorno Linux compatible.


## Contacto

Este proyecto forma parte del módulo de Big Data Aplicado y Procesamiento y Automatización (PIA).

Para más información, revisa la carpeta docs/ o contacta con el equipo responsable del desarrollo.


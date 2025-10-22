# Reto 0 - Big Data Aplicado (BDA)

Este documento describe de forma detallada cada una de las tareas realizadas dentro del Reto 0 de Big Data Aplicado, organizando la información por fases del reto y tecnologías utilizadas. 

El objetivo es monitorizar y visualizar datos meteorológicos en tiempo real desde múltiples fuentes, procesarlos, almacenarlos y presentarlos mediante dashboards en Grafana.

---

## Tareas realizadas 

### 1. Crear flujo en Node-RED para obtener datos de diferentes ciudades desde OpenWeather

- Se ha creado un flujo en Node-RED que solicita datos meteorológicos cada 10 segundos para las ciudades de:
  - Madrid
  - Bilbao
  - Barcelona
  - Sevilla

- Este flujo envía los datos directamente al bucket `RETO0-Data` en InfluxDB.
- Se ha estructurado el flujo con:
  - `inject`
  - `http request`
  - `function` (formateo y estructura)
  - `influxdb out`

---

### 2. Crear un segundo flujo con datos generados desde script externo en Python

- Se ha desarrollado el script `weather_current.py` para consultar los datos meteorológicos de la ciudad de **Granada** utilizando la API de OpenWeather.
- El script:
  - Se ejecuta durante 1 hora con intervalo de 10 segundos.
  - Inserta los datos en el bucket `RETO0-PANDAS`.
  - Almacena logs en `logs/weather_granada.log`.
  - Incluye campo `fecha_hora`, además de los datos meteorológicos habituales.

---

### 3. Crear dos dashboards diferentes en Grafana

- **Dashboard 1 - Node-RED (`Data-Real-Time-Node-red.json`)**
  - Consulta datos del bucket `RETO0-Data`.
  - Presenta paneles con datos de temperatura por ciudad.
  - Incluye alerta si alguna ciudad supera los 29 ºC.

- **Dashboard 2 - Python/Pandas (`Data-Real-Time-Pandas.json`)**
  - Muestra los datos de temperatura y humedad en Granada.
  - Incluye alerta si la temperatura supera los 20 ºC.

---

### 4. Almacenar y visualizar los datos en InfluxDB

- InfluxDB almacena los datos en dos buckets:
  - `RETO0-Data`: desde Node-RED
  - `RETO0-PANDAS`: desde script Python
- Los datos se visualizan y filtran por:
  - Measurement: `weather-realtime` y `weather-realtime-pandas`
  - Tag: `tag_ciudad` o `ciudad`

---

### 5. Configurar alertas en Grafana

- Se ha configurado una alerta por cada dashboard:
  - Node-RED: si alguna ciudad supera los 29 ºC.
  - Pandas: si Granada supera los 20 ºC.

---

### 6. Crear equipos y asignar permisos en Grafana

Se han creado los siguientes equipos con sus permisos:

| Equipo                  | Permisos                          |
|-------------------------|------------------------------------|
| Cúpula Directiva        | Solo visualización                |
| Departamento Análisis   | Visualización de dashboards       |
| Departamento IT         | Gestión total, edición, alertas   |

---

## Flujo de Datos Completo

1. Node-RED solicita datos de 4 ciudades → transforma → envía a InfluxDB → se visualiza en Grafana
2. Python solicita datos de Granada → guarda en InfluxDB → se visualiza en Grafana

---

## Buckets y Campos

| Bucket         | Fuente          | Measurement               | Campos principales                              | Tags           |
|----------------|-----------------|---------------------------|--------------------------------------------------|----------------|
| RETO0-Data     | Node-RED        | `weather-realtime`        | `temperatura`, `humedad`, `presion`, etc.       | `tag_ciudad`   |
| RETO0-PANDAS   | Python (Pandas) | `weather-realtime-pandas` | `temperatura`, `humedad`, `viento_velocidad`... | `ciudad`       |

---

## Cómo ejecutar el script Python

0. Ubícate en la raíz del repositorio.

1. Crea el archivo `.env` a partir del `.env.example` con tus claves.

2. Activa el entorno virtual:

    ```bash
    source venv/bin/activate
    ```

3. Instala dependencias si es necesario:

    ```bash
    pip install -r requirements.txt
    ```

4. Ejecuta el script:

    ```bash
    python services/python-scripts/weather_current.py
    ```

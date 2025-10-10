# ---
# WEATHER REALTIME GRANADA → InfluxDB (RETO0-Data)
# ---

from influxdb_client import InfluxDBClient, Point, WritePrecision
from influxdb_client.client.write_api import SYNCHRONOUS
import requests
from datetime import datetime, timedelta
import time
import logging
import os
from dotenv import load_dotenv

# --- CARGAR VARIABLES DEL ARCHIVO .env ---
load_dotenv()

# --- CONFIGURACIÓN DE LOGS ---
os.makedirs("../logs", exist_ok=True)
logging.basicConfig(
    filename="../logs/weather_granada.log",
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S"
)

logging.info("🚀 Inicio del proceso de subida de datos a InfluxDB desde OpenWeather (Granada)")

# --- LEER VARIABLES DE ENTORNO ---
url_influx = os.getenv("INFLUX_URL")
token = os.getenv("INFLUX_TOKEN")
org = os.getenv("INFLUX_ORG")
bucket = os.getenv("INFLUX_BUCKET")
API_KEY = os.getenv("OW_API_KEY")
CITY = os.getenv("OW_CITY")

URL = f"http://api.openweathermap.org/data/2.5/weather?q={CITY}&appid={API_KEY}&units=metric"

# --- CONEXIÓN A INFLUXDB ---
client = InfluxDBClient(url=url_influx, token=token, org=org)
write_api = client.write_api(write_options=SYNCHRONOUS)

# --- FUNCIÓN PRINCIPAL ---
def obtener_datos():
    try:
        response = requests.get(URL)
        data = response.json()

        if response.status_code == 200:
            punto = Point("weather-realtime-pandas") \
                .tag("ciudad", data["name"]) \
                .field("temperatura", float(data["main"]["temp"])) \
                .field("sensacion_termica", float(data["main"]["feels_like"])) \
                .field("humedad", int(data["main"]["humidity"])) \
                .field("presion", int(data["main"]["pressure"])) \
                .field("viento_velocidad", float(data["wind"]["speed"])) \
                .field("viento_direccion", int(data["wind"].get("deg", 0))) \
                .time(datetime.utcnow(), WritePrecision.NS)

            write_api.write(bucket=bucket, org=org, record=punto)
            mensaje = f"✅ Datos insertados en InfluxDB ({data['name']}) | 🌡️ {data['main']['temp']}°C | 💧 {data['main']['humidity']}% | 🌬️ {data['wind']['speed']} m/s"
            print(mensaje)
            logging.info(mensaje)

        else:
            error_msg = f"❌ Error en la respuesta: {data}"
            print(error_msg)
            logging.error(error_msg)

    except Exception as e:
        error_msg = f"⚠️ Error en la conexión o escritura: {e}"
        print(error_msg)
        logging.error(error_msg)


# --- BUCLE PRINCIPAL ---
print("1️⃣ Iniciando envío de datos en tiempo real (duración máxima: 1 hora).")
print("2️⃣ Puedes detener el proceso en cualquier momento con Ctrl + C.\n")

inicio = datetime.now()
duracion = timedelta(hours=1)

try:
    while datetime.now() - inicio < duracion:
        obtener_datos()
        time.sleep(10)
except KeyboardInterrupt:
    print("\n🛑 Proceso interrumpido manualmente por el usuario.")
    logging.warning("🛑 Proceso interrumpido manualmente por el usuario.")
finally:
    client.close()
    print("🔚 Conexión cerrada. Ejecución finalizada correctamente.")
    logging.info("🔚 Conexión cerrada. Ejecución finalizada correctamente.\n")


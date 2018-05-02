#! /bin/sh

# Define env variables:
#   KHOR_DIR
#   KAFKA_DIR
#
# Add the followong lines to .bashrc file or before starting this script
# export KHOR_DIR=path/to/khor/root/dir
# export KAFKA_DIR=path/to/kafka/root/dir

# define variables
PATH_KAFKA=$KAFKA_DIR
PATH_KHOR=$KHOR_DIR
PATH_TOPICMONITOR="hum1703-topicmonitor"
PATH_ADMINISTRATION="hum1703-administracion"
PATH_INVENTORY="hum1703-inventario"
PATH_PREFERENCES="hum1703-preferencias"
PATH_PSICHOMETRY="hum1703-psicometria"
PATH_REPORTS="hum1703-reportes"
PATH_NOTIFICATIONS="hum1703-notificaciones"
PATH_ENDPOINT="hum1703-endpoint"
PATH_WEB="hum1703-web"
PATH_KHOR_DEFAULT="/workspace/khor2"
PATH_KAFKA_DEFAULT="/kafka_2.11-1.0.1"
ROOT_PATH=$PWD

echo "working dir: $ROOT_PATH"
# validate flags, if not present start with defaults
# kafka dir
if [ -z "$PATH_KAFKA"]
then
  PATH_KAFKA="$HOME$PATH_KAFKA_DEFAULT"
  echo "KAFKA_DIR env variable is not defined, setting default path: $PATH_KAFKA"
fi

if [ -z "$PATH_KHOR"]
then
  PATH_KHOR="$HOME$PATH_KHOR_DEFAULT"
  echo "KHOR_DIR env variable is not defined, setting default path: $PATH_KHOR"
fi

echo "starting zookeper from dir: " $PATH_KAFKA
nohup "$PATH_KAFKA/bin/zookeeper-server-start.sh" "$PATH_KAFKA/config/zookeeper.properties" 1> "$ROOT_PATH/zookeeper.out" 2>&1 & echo zookeper server started with pid: $!

echo "starting kafka from dir: " $PATH_KAFKA
nohup "$PATH_KAFKA/bin/kafka-server-start.sh" "$PATH_KAFKA/config/server.properties" 1> "$ROOT_PATH/kafka.out" 2>&1 & echo "kafka server started pid: $!"

echo "starting microservice: administracion"
echo "changing to dir: $PATH_KHOR/$PATH_ADMINISTRATION"
cd "$PATH_KHOR/$PATH_ADMINISTRATION"
nohup gradle bootRun 1> "$ROOT_PATH/administracion.out" 2>&1 & echo "microservice: administracion started with pid: $!"

echo "starting microservice: inventario"
echo "changing to dir: $PATH_KHOR/$PATH_INVENTORY"
cd "$PATH_KHOR/$PATH_INVENTORY"
nohup gradle bootRun 1> "$ROOT_PATH/inventario.out" 2>&1 & echo "microservice: inventario started with pid: $!"

echo "starting microservice: preferencias"
echo "changing to dir: $PATH_KHOR/$PATH_PREFERENCES"
cd "$PATH_KHOR/$PATH_PREFERENCES"
nohup gradle bootRun 1> "$ROOT_PATH/preferencias.out" 2>&1 & echo "microservice: administracion started with pid: $!"

# start psychometry ms
#echo 'starting microservice: psychometry'
#cd "$KHOR_DIR/$PATH_PSICHOMETRY"
#npm install
#node seeder.js
#nohup npm start &

# start zookeeper
# start kafka

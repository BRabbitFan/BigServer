#!/bin/bash

redis=$(ps -ef | grep redis)
redis=${redis%% *}
mysql=$(ps -ef | grep mysql)
mysql=${mysql%% *}

if [[ "$redis" == "redis" ]]; then
  echo "[BigServer] redis start allready"
else
  echo "[BigServer] redis starting..."
  sudo service redis-server start
  echo "[BigServer] redis start success"
fi

if [[ "$mysql" == "mysql" ]]; then
  echo "[BigServer] mysql start allready"
else
  echo "[BigServer] mysql starting..."
  sudo service mysql start
  echo "[BigServer] mysql start success"
fi

echo "[BigServer] skynet starting"
./skynet/skynet conf/server_config
echo "[BigServer] skynet start success"
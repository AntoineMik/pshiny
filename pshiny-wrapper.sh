#!/bin/bash
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
port="8888"
delim='='
for var in "$@"
  do
    echo "$var"
    splitarg=${var%%$delim*}
    if [ "$splitarg" == "--port" ]; then
      # Yes, port was given in one arg e.g. --port=8888
      port=${var#*$delim}
      echo "Setting external port $port"
    fi
done

source /opt/apps/lmod/lmod/init/profile
module load $( echo ${USER_OPTIONS} | tr "'" '"' | jq -r '.modules' )

DASHBOARD="`python /usr/local/pshiny/json_get_dashboard_name.py`"

# Get the file directory
APP_DIR=$(dirname $DASHBOARD)

# Get the file name
APP_FILE=$(basename $DASHBOARD)

# file name base without extension
APP_FILE_NAME=${APP_FILE%.*}


jhsingle-native-proxy --authtype=none --destport 8505 uvicorn {--}reload {--}reload-dir $APP_DIR {--}app-dir $APP_DIR $APP_FILE_NAME:app {--}port {port} --port $port

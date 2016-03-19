#!/usr/bin/env bash


echo 'runnnig alluxo-layout.sh we should change the exports to alluxio'
export ALLUXIO_SYSTEM_INSTALLATION="TRUE"
echo "setting alluxio_prefix and alluxio_home to different paths"
export ALLUXIO_PREFIX="/usr/lib/alluxio"
export ALLUXIO_HOME="/var/lib/alluxio"
export ALLUXIO_CONF_DIR="/etc/alluxio/conf"
export ALLUXIO_LOGS_DIR="/var/log/alluxio"
export ALLUXIO_DATA_DIR="/var/run/alluxio"
echo "before the fucked up find statement in alluxio-layout.sh ALLUXIO_JAR before setting:"
echo "ALLUXIO_JAR:$ALLUXIO_JAR"
export ALLUXIO_JAR="`find / -name alluxio*dependencies.jar|grep -v client`"
echo "after the fucked up find statement ALLUXIO_JAR:$ALLUXIO_JAR"
echo "we need to reset ALLUXIO_JAR"
export ALLUXIO_JAR=/usr/lib/alluxio/alluxio-0.6.0-jar-with-dependencies.jar:/usr/lib/alluxio/alluxio-client-0.6.0-jar-with-dependencies.jar
echo "after manual setting ALLUXIO_JAR:$ALLUXIO_JAR"

# find JAVA_HOME
. /usr/lib/bigtop-utils/bigtop-detect-javahome

if [ -z "JAVA_HOME" ]; then
  export JAVA="/usr/bin/java"
else
  export JAVA="$JAVA_HOME/bin/java"
fi
echo "end alluxio-layout.sh"

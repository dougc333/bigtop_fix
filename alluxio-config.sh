#!/usr/bin/env bash
echo "running alluxio-config.sh"

# Included in all the Alluxio scripts with source command should not be executable directly also
# should not be passed any arguments, since we need original $*

# resolve links - $0 may be a softlink
this="${BASH_SOURCE-$0}"
common_bin=$(cd -P -- "$(dirname -- "$this")" && pwd -P)
script="$(basename -- "$this")"
this="$common_bin/$script"

# convert relative path to absolute path
config_bin=`dirname "$this"`
script=`basename "$this"`
config_bin=`cd "$config_bin"; pwd`
this="$config_bin/$script"

# Allow for a script which overrides the default settings for system integration folks.
[ -f "$common_bin/alluxio-layout.sh" ] && . "$common_bin/alluxio-layout.sh"

# This will set the default installation for a tarball installation while os distributors can create
# their own tachyon-layout.sh file to set system installation locations.
if [ -z "$TACHYON_SYSTEM_INSTALLATION" ]; then
  export ALLUXIO_PREFIX="/usr/lib/alluxio"
  export ALLUXIO_HOME=${ALLUXIO_PREFIX}
  export ALLUXIO_CONF_DIR="/etc/alluxio/conf"
  export ALLUXIO_LOGS_DIR="$ALLUXIO_HOME/logs"
  export ALLUXIO_JAR=/usr/lib/alluxio/alluxio-0.6.0-jar-with-dependencies.jar:/usr/lib/alluxio/alluxio-client-0.6.0-jar-with-dependencies.jar
  export JAVA="$JAVA_HOME/bin/java"
fi

# Environment settings should override * and are administrator controlled.
if [ -e $ALLUXIO_CONF_DIR/alluxio-env.sh ] ; then
  . $ALLUXIO_CONF_DIR/alluxio-env.sh
fi

export CLASSPATH="$ALLUXIO_CONF_DIR/:$ALLUXIO_CLASSPATH:$ALLUXIO_JAR"

echo "end alluxio-config.sh"

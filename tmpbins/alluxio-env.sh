#!/usr/bin/env bash

# This file contains environment variables required to run Tachyon. Copy it as tachyon-env.sh and
# edit that to configure Tachyon for your site. At a minimum,
# the following variables should be set:
#
# - JAVA_HOME, to point to your JAVA installation
# - TACHYON_MASTER_ADDRESS, to bind the master to a different IP address or hostname
# - TACHYON_UNDERFS_ADDRESS, to set the under filesystem address.
# - TACHYON_WORKER_MEMORY_SIZE, to set how much memory to use (e.g. 1000mb, 2gb) per worker
# - TACHYON_RAM_FOLDER, to set where worker stores in memory data
# - TACHYON_UNDERFS_HDFS_IMPL, to set which HDFS implementation to use (e.g. com.mapr.fs.MapRFileSystem,
#   org.apache.hadoop.hdfs.DistributedFileSystem)

# The following gives an example:

# Uncomment this section to add a local installation of Hadoop to Tachyon's CLASSPATH.
# The hadoop command must be in the path to automatically populate the Hadoop classpath.
#
# if type "hadoop" > /dev/null 2>&1; then
#  export HADOOP_TACHYON_CLASSPATH=`hadoop classpath`
# fi
# export TACHYON_CLASSPATH=$HADOOP_TACHYON_CLASSPATH

echo "ALLUXIO_CLASSPATH:$ALLUXIO_CLASSPATH"
echo "HADOOP_ALLUXIO_CLASSPATH:$HADOOP_ALLUXIO_CLASSPATH"


if [[ `uname -a` == Darwin* ]]; then
  # Assuming Mac OS X
  export JAVA_HOME=${JAVA_HOME:-$(/usr/libexec/java_home)}
  export ALLUXIO_RAM_FOLDER=/Volumes/ramdisk
  export ALLUXIO_JAVA_OPTS="-Djava.security.krb5.realm= -Djava.security.krb5.kdc="
else
  # Assuming Linux
  if [ -z "$JAVA_HOME" ]; then
    if [ -d /usr/lib/jvm/java-7-oracle ]; then
      export JAVA_HOME=/usr/lib/jvm/java-7-oracle
    else
      # openjdk will set this
      if [ -d /usr/lib/jvm/jre-1.7.0 ]; then
        export JAVA_HOME=/usr/lib/jvm/jre-1.7.0
      fi
    fi
  fi
  export ALLUXIO_RAM_FOLDER=/mnt/ramdisk
fi

if [ -z "$JAVA_HOME" ]; then
  export JAVA_HOME="$(dirname $(which java))/.."
fi

export JAVA="$JAVA_HOME/bin/java"
export ALLUXIO_MASTER_ADDRESS=localhost
export ALLUXIO_UNDERFS_ADDRESS=$TACHYON_HOME/underfs
#export ALLUXIO_UNDERFS_ADDRESS=hdfs://localhost:9000
export ALLUXIO_WORKER_MEMORY_SIZE=1GB
export ALLUXIO_UNDERFS_HDFS_IMPL=org.apache.hadoop.hdfs.DistributedFileSystem

CONF_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export ALLUXIO_JAVA_OPTS+="
  -Dlog4j.configuration=file:$CONF_DIR/log4j.properties
  -Dalluxio.debug=false
  -Dalluxio.worker.hierarchystore.level.max=1
  -Dalluxio.worker.hierarchystore.level0.alias=MEM
  -Dalluxio.worker.hierarchystore.level0.dirs.path=$TACHYON_RAM_FOLDER
  -Dalluxio.worker.hierarchystore.level0.dirs.quota=$TACHYON_WORKER_MEMORY_SIZE
  -Dalluxio.underfs.address=$TACHYON_UNDERFS_ADDRESS
  -Dalluxio.underfs.hdfs.impl=$TACHYON_UNDERFS_HDFS_IMPL
  -Dalluxio.data.folder=$TACHYON_UNDERFS_ADDRESS/tmp/tachyon/data
  -Dalluxio.workers.folder=$TACHYON_UNDERFS_ADDRESS/tmp/tachyon/workers
  -Dalluxio.worker.memory.size=$TACHYON_WORKER_MEMORY_SIZE
  -Dalluxio.worker.data.folder=/tachyonworker/
  -Dalluxio.master.worker.timeout.ms=60000
  -Dalluxio.master.hostname=$TACHYON_MASTER_ADDRESS
  -Dalluxio.master.journal.folder=$TACHYON_HOME/journal/
  -Dorg.apache.jasper.compiler.disablejsr199=true
  -Djava.net.preferIPv4Stack=true
"

# Master specific parameters. Default to TACHYON_JAVA_OPTS.
export ALLUXIO_MASTER_JAVA_OPTS="$ALLUXIO_JAVA_OPTS"

# Worker specific parameters that will be shared to all workers. Default to TACHYON_JAVA_OPTS.
export ALLUXIO_WORKER_JAVA_OPTS="$ALLUXIO_JAVA_OPTS"

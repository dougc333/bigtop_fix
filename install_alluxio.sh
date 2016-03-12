
#!/bin/bash

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -ex

usage() {
  echo "
usage: $0 <options>
  Required not-so-options:
     --build-dir=DIR             path to Tachyon dist.dir
     --prefix=PREFIX             path to install into

  Optional options:
     --bin-dir=DIR               path to install bin
     --data-dir=DIR              path to install local Tachyon data
     ... [ see source for more similar options ]
  "
  exit 1
}

OPTS=$(getopt \
  -n $0 \
  -o '' \
  -l 'prefix:' \
  -l 'bin-dir:' \
  -l 'libexec-dir:' \
  -l 'var-dir:' \
  -l 'lib-dir:' \
  -l 'data-dir:' \
  -l 'build-dir:' -- "$@")

if [ $? != 0 ] ; then
    usage
fi

eval set -- "$OPTS"
while true ; do
    case "$1" in
        --prefix)
        PREFIX=$2 ; shift 2
        ;;
        --build-dir)
        BUILD_DIR=$2 ; shift 2
        ;;
        --libexec-dir)
        LIBEXEC_DIR=$2 ; shift 2
        ;;
        --lib-dir)
        LIB_DIR=$2 ; shift 2
        ;;
        --bin-dir)
        BIN_DIR=$2 ; shift 2
        ;;
        --var-dir)
        VAR_DIR=$2 ; shift 2
        ;;
        --data-dir)
        DATA_DIR=$2 ; shift 2
        ;;
        --)
        shift ; break
        ;;
        *)
        echo "Unknown option: $1"
        usage
        exit 1
        ;;
    esac
done

for var in PREFIX BUILD_DIR ; do
  if [ -z "$(eval "echo \$$var")" ]; then
    echo Missing param: $var
    usage
  fi
done

ALLUXIO_LIB_DIR=${ALLUXIO_LIB_DIR:-/usr/lib/alluxio}
LIBEXEC_DIR=${INSTALLED_LIB_DIR:-/usr/libexec}
BIN_DIR=${BIN_DIR:-/usr/bin}

echo "PREFIX:$PREFIX"
echo "LIB_DIR:$LIB_DIR"
echo "ALLUXIO_LIB_DIR:$ALLUXIO_LIB_DIR"
echo "DATA_DIR:$DATA_DIR"
echo "is this BUILDROOT OR BUILD?"

#install -d -m 0755 $PREFIX/$LIB_DIR
install -d -m 0755 $PREFIX/$ALLUXIO_LIB_DIR
#install -d -m 0755 $PREFIX/$LIB_DIR/bin
install -d -m 0755 $PREFIX/$ALLUXIO_LIB_DIR/bin
#install -d -m 0755 $PREFIX/$LIB_DIR/libexec
install -d -m 0755 $PREFIX/$ALLUXIO_LIB_DIR/libexec
#install -d -m 0755 $PREFIX/$LIB_DIR/lib
install -d -m 0755 $PREFIX/$ALLUXIO_LIB_DIR/lib
#install -d -m 0755 $PREFIX/$LIB_DIR/share
install -d -m 0755 $PREFIX/$ALLUXIO_LIB_DIR/share
install -d -m 0755 $PREFIX/$DATA_DIR
#install -d -m 0755 $PREFIX/$DATA_DIR/tachyon
install -d -m 0755 $PREFIX/$DATA_DIR/alluxio
install -d -m 0755 $PREFIX/etc
#install -d -m 0755 $PREFIX/etc/tachyon
install -d -m 0755 $PREFIX/etc/alluxio
#install -d -m 0755 $PREFIX/etc/tachyon/conf
install -d -m 0755 $PREFIX/etc/alluxio/conf
#install -d -m 0755 $PREFIX/$VAR_DIR/log/tachyon
install -d -m 0755 $PREFIX/$VAR_DIR/log/alluxio
#install -d -m 0755 $PREFIX/$VAR_DIR/lib/tachyon/journal
install -d -m 0755 $PREFIX/$VAR_DIR/lib/alluxio/journal
#install -d -m 0755 $PREFIX/$VAR_DIR/lib/tachyon/core/src/main/webapp
install -d -m 0755 $PREFIX/$VAR_DIR/lib/alluxio/core/src/main/webapp
ln -s $VAR_DIR/log/alluxio $PREFIX/$VAR_DIR/lib/alluxio/logs
#install -d -m 0755 $PREFIX/$VAR_DIR/run/tachyon
install -d -m 0755 $PREFIX/$VAR_DIR/run/alluxio


#cp -ra ${BUILD_DIR}/lib/* $PREFIX/${LIB_DIR}/lib/
echo 'copying to tachyon dir jar files'
#cp client/target/tachyon-client*.jar core/target/tachyon*.jar $PREFIX/$LIB_DIR
#break this up to the 7 files changing the names
#cp client/target/tachyon-client*.jar core/target/tachyon*.jar $PREFIX/$ALLUXIO_LIB_DIR
cp client/target/tachyon-client-0.6.0.jar $PREFIX/$ALLUXIO_LIB_DIR/alluxio-client-0.6.0.jar
cp client/target/tachyon-client-0.6.0-jar-with-dependencies.jar $PREFIX/$ALLUXIO_LIB_DIR/alluxio-client-0.6.0-jar-with-dependencies.jar
cp core/target/tachyon-0.6.0.jar $PREFIX/$ALLUXIO_LIB_DIR/alluxio-0.6.0.jar
cp core/target/tachyon-0.6.0-jar-with-dependencies.jar $PREFIX/$ALLUXIO_LIB_DIR/alluxio-0.6.0-jar-with-dependencies.jar
cp core/target/tachyon-0.6.0-javadoc.jar $PREFIX/$ALLUXIO_LIB_DIR/alluxio-0.6.0-javadoc.jar
cp core/target/tachyon-0.6.0-sources.jar $PREFIX/$ALLUXIO_LIB_DIR/alluxio-0.6.0-sources.jar
cp core/target/tachyon-0.6.0-tests.jar $PREFIX/$ALLUXIO_LIB_DIR/alluxio-0.6.0-tests.jar
echo "done copying and renaming tachyon jars to alluxio"

#cp -a bin/* $PREFIX/${LIB_DIR}/bin
#echo 'end copying to prefix/bin/'
echo "copying bin/files to allusiolibdir bin"
cp -a bin/* $PREFIX/${ALLUXIO_LIB_DIR}/bin
echo "come back here and change cp to mv"
echo "PREFIX:$PREFIX and ALLUXIO_LIB_DIR:$ALLUXIO_LIB_DIR"
mv $PREFIX/${ALLUXIO_LIB_DIR}/bin/tachyon $PREFIX/${ALLUXIO_LIB_DIR}/bin/alluxio
mv $PREFIX/${ALLUXIO_LIB_DIR}/bin/tachyon-start.sh $PREFIX/${ALLUXIO_LIB_DIR}/bin/alluxio-start.sh
mv $PREFIX/${ALLUXIO_LIB_DIR}/bin/tachyon-stop.sh $PREFIX/${ALLUXIO_LIB_DIR}/bin/alluxio-stop.sh
mv $PREFIX/${ALLUXIO_LIB_DIR}/bin/tachyon-workers.sh $PREFIX/${ALLUXIO_LIB_DIR}/bin/alluxio-workers.sh
mv $PREFIX/${ALLUXIO_LIB_DIR}/bin/tachyon-mount.sh $PREFIX/${ALLUXIO_LIB_DIR}/bin/alluxio-mount.sh

echo 'end copyong to prefix/alluxio_lib_dir/bin'
#cp -a libexec/* $PREFIX/${LIB_DIR}/libexec
#echo 'end copyong prefix/lib_dir/libexec'
echo "start copy libexec/* to alluxio libexec"
cp -a libexec/* $PREFIX/${ALLUXIO_LIB_DIR}/libexec
echo 'copying webapp to alluxio'
#cp -rf core/src/main/webapp $PREFIX/$VAR_DIR/lib/tachyon/core/src/main
cp -rf core/src/main/webapp $PREFIX/$VAR_DIR/lib/alluxio/core/src/main

# Copy in the configuration files
#install -m 0644 conf/log4j.properties conf/workers $PREFIX/etc/tachyon/conf
install -m 0644 conf/log4j.properties conf/workers $PREFIX/etc/alluxio/conf
#cp conf/tachyon-env.sh.template $PREFIX/etc/tachyon/conf/tachyon-env.sh
cp conf/tachyon-env.sh.template $PREFIX/etc/alluxio/conf/alluxio-env.sh


# Copy in the /usr/bin/tachyon wrapper
echo "I dont understand the tachyon wrapper"
install -d -m 0755 $PREFIX/$BIN_DIR
echo "tachyon wrapper PREFIX:$PREFIX"
echo "tachyon wrapper BIN_DIR:$BIN_DIR"


# Copy in tachyon deploy scripts
echo "copy in the alluxio/tacyhyon deploy ssciprts"

#cp -rf deploy $PREFIX/$LIB_DIR/share
cp -rf deploy $PREFIX/$ALLUXIO_LIB_DIR/share
echo 'end tachyon deploy scripts'

# Prefix is correct at time of install,
# but we dont want to escape it before that point.
#echo 'note to self, look in binary tachyon and alluxio for EOF'
#cat > $PREFIX/$BIN_DIR/tachyon <<EOF
#!/bin/bash

# Autodetect JAVA_HOME if not defined
. /usr/bin/bigtop-detect-javahome
# Lib dir => ${LIB_DIR}
#!/usr/bin/env bash
#exec ${LIB_DIR}/bin/tachyon "\$@"
#EOF
#chmod 755 $PREFIX/$BIN_DIR/tachyon
echo "looking for tachyon executuable"
echo "prefix: $PREFIX"
echo "bin_dir: $BIN_DIR"
#what are we doing here? we are copying * from BUILDROOT/alluxio-tfs-xx/usr/lib/alluxio/bin
#to BUILD?
#cp $PREFIX/$BIN_DIR/tachyon $PREFIX/$BIN_DIR/alluxio

#chmod 755 $PREFIX/$BIN_DIR/alluxio
#this is tricky, it creates the actual file tachyon-layout.sh. Cool. Replicate
mv $PREFIX/$ALLUXIO_LIB_DIR/libexec/tachyon-config.sh $PREFIX/$ALLUXIO_LIB_DIR/libexec/alluxio-config.sh
mv $PREFIX/$ALLUXIO_LIB_DIR/libexec/tachyon-layout.sh.linux.template $PREFIX/$ALLUXIO_LIB_DIR/libexec/alluxio-layout.sh.linux.template

cat >$PREFIX/$ALLUXIO_LIB_DIR/libexec/alluxio-layout.sh <<EOF
#!/usr/bin/env bash

echo 'we should change the exports to alluxio'
export ALLUXIO_SYSTEM_INSTALLATION="TRUE"
export ALLUXIO_PREFIX="$ALLUXIO_LIB_DIR"
export ALLUXIO_HOME="/var/lib/alluxio"
export ALLUXIO_CONF_DIR="/etc/alluxio/conf"
export ALLUXIO_LOGS_DIR="/var/log/alluxio"
export ALLUXIO_DATA_DIR="/var/run/alluxio"
export ALLUXIO_JAR="\`find $ALLUSIO_LIB_DIR/ -name alluxio*dependencies.jar|grep -v client\`"

# find JAVA_HOME
. /usr/lib/bigtop-utils/bigtop-detect-javahome

if [ -z "JAVA_HOME" ]; then
  export JAVA="/usr/bin/java"
else
  export JAVA="\$JAVA_HOME/bin/java"
fi
EOF

echo "end install_alluxio.sh"

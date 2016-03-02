
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
echo 'prefix:$PREFIX and build_dir:$BUILD_DIR have to be set'
echo 'before the install LIB_DIR:$LIB_DIR'
echo $LIB_DIR
echo 'we concatenate /usr/lib/tachyon to LIB_DIR'
LIB_DIR=${LIB_DIR:-/usr/lib/tachyon}
echo 'after assignment $LIBDIR'
echo $LIB_DIR
ALLUXIO_LIB_DIR=${ALLUXIO_LIB_DIR:-/usr/lib/alluxio}
echo 'alluxio_lib_dir' $ALLUXIO_LIB_DIR
echo 'installed_lib_dir' $INSTALLED_LIB_DIR
echo 'bin_dir' $BIN_DIR
echo 'prefix:' $PREFIX
LIBEXEC_DIR=${INSTALLED_LIB_DIR:-/usr/libexec}
BIN_DIR=${BIN_DIR:-/usr/bin}

install -d -m 0755 $PREFIX/$LIB_DIR
install -d -m 0755 $PREFIX/$ALLUXIO_LIB_DIR
install -d -m 0755 $PREFIX/$LIB_DIR/bin
install -d -m 0755 $PREFIX/$ALLUXIO_LIB_DIR/bin
install -d -m 0755 $PREFIX/$LIB_DIR/libexec
install -d -m 0755 $PREFIX/$ALLUXIO_LIB_DIR/libexec
install -d -m 0755 $PREFIX/$LIB_DIR/lib
install -d -m 0755 $PREFIX/$ALLUXIO_LIB_DIR/lib
install -d -m 0755 $PREFIX/$LIB_DIR/share
install -d -m 0755 $PREFIX/$ALLUXIO_LIB_DIR/share
install -d -m 0755 $PREFIX/$DATA_DIR
install -d -m 0755 $PREFIX/$DATA_DIR/tachyon
install -d -m 0755 $PREFIX/$DATA_DIR/alluxio
install -d -m 0755 $PREFIX/etc
install -d -m 0755 $PREFIX/etc/tachyon
install -d -m 0755 $PREFIX/etc/alluxio
install -d -m 0755 $PREFIX/etc/tachyon/conf
install -d -m 0755 $PREFIX/etc/alluxio/conf
install -d -m 0755 $PREFIX/$VAR_DIR/log/tachyon
install -d -m 0755 $PREFIX/$VAR_DIR/log/alluxio
install -d -m 0755 $PREFIX/$VAR_DIR/lib/tachyon/journal
install -d -m 0755 $PREFIX/$VAR_DIR/lib/alluxio/journal
install -d -m 0755 $PREFIX/$VAR_DIR/lib/tachyon/core/src/main/webapp
install -d -m 0755 $PREFIX/$VAR_DIR/lib/alluxio/core/src/main/webapp
ln -s $VAR_DIR/log/tachyon $PREFIX/$VAR_DIR/lib/tachyon/logs
install -d -m 0755 $PREFIX/$VAR_DIR/run/tachyon
install -d -m 0755 $PREFIX/$VAR_DIR/run/alluxio


#cp -ra ${BUILD_DIR}/lib/* $PREFIX/${LIB_DIR}/lib/
cp client/target/tachyon-client*.jar core/target/tachyon*.jar $PREFIX/$LIB_DIR
cp client/target/tachyon-client*.jar core/target/tachyon*.jar $PREFIX/$ALLUXIO_LIB_DIR

cp -a bin/* $PREFIX/${LIB_DIR}/bin
echo 'end copying to prefix/bin/'
cp -a bin/* $PREFIX/${ALLUXIO_LIB_DIR}/bin
echo 'end copyong to prefix/alluxio_lib_dir/bin'
cp -a libexec/* $PREFIX/${LIB_DIR}/libexec
echo 'end copyong prefix/lib_dir/libexec'
cp -a libexec/* $PREFIX/${ALLUXIO_LIB_DIR}/libexec
echo 'copying to prefix/alluxio_lib_dir'
cp -rf core/src/main/webapp $PREFIX/$VAR_DIR/lib/tachyon/core/src/main
cp -rf core/src/main/webapp $PREFIX/$VAR_DIR/lib/alluxio/core/src/main

# Copy in the configuration files
install -m 0644 conf/log4j.properties conf/workers $PREFIX/etc/tachyon/conf
install -m 0644 conf/log4j.properties conf/workers $PREFIX/etc/alluxio/conf
cp conf/tachyon-env.sh.template $PREFIX/etc/tachyon/conf/tachyon-env.sh
cp conf/tachyon-env.sh.template $PREFIX/etc/alluxio/conf/alluxio-env.sh


# Copy in the /usr/bin/tachyon wrapper
echo "I dont understand the tachyon wrapper"
install -d -m 0755 $PREFIX/$BIN_DIR
echo 'we need to cp tachyon to alluxio for the executables?'

# Copy in tachyon deploy scripts
cp -rf deploy $PREFIX/$LIB_DIR/share
cp -rf deploy $PREFIX/$ALLUXIO_LIB_DIR/share
echo 'end tachyon deploy scripts'

# Prefix is correct at time of install,
# but we dont want to escape it before that point.
echo 'note to self, look in binary tachyon and alluxio for EOF'
cat > $PREFIX/$BIN_DIR/tachyon <<EOF
#!/bin/bash

# Autodetect JAVA_HOME if not defined
. /usr/lib/bigtop-utils/bigtop-detect-javahome
# Lib dir => ${LIB_DIR}
#!/usr/bin/env bash
exec ${LIB_DIR}/bin/tachyon "\$@"
EOF
chmod 755 $PREFIX/$BIN_DIR/tachyon
cp $PREFIX/$BIN_DIR/tachyon $PREFIX/$BIN_DIR/alluxio

chmod 755 $PREFIX/$BIN_DIR/alluxio
#this is tricky, it creates the actual file tachyon-layout.sh. Cool. Replicate
#for alluxio
cat >$PREFIX/$LIB_DIR/libexec/tachyon-layout.sh <<EOF
#!/usr/bin/env bash

echo 'we should change the exports to alluxio'
export TACHYON_SYSTEM_INSTALLATION="TRUE"
export TACHYON_PREFIX="$LIB_DIR"
export TACHYON_HOME="/var/lib/tachyon"
export TACHYON_CONF_DIR="/etc/tachyon/conf"
export TACHYON_LOGS_DIR="/var/log/tachyon"
export TACHYON_DATA_DIR="/var/run/tachyon"
export TACHYON_JAR="\`find $LIB_DIR/ -name tachyon*dependencies.jar|grep -v client\`"

# find JAVA_HOME
. /usr/lib/bigtop-utils/bigtop-detect-javahome

if [ -z "JAVA_HOME" ]; then
  export JAVA="/usr/bin/java"
else
  export JAVA="\$JAVA_HOME/bin/java"
fi
EOF


cat >$PREFIX/$ALLUXIO_LIB_DIR/libexec/alluxio-layout.sh <<EOF
#!/usr/bin/env bash

echo 'we should change the exports to alluxio'
export TACHYON_SYSTEM_INSTALLATION="TRUE"
export TACHYON_PREFIX="$ALLUXIO_LIB_DIR"
export TACHYON_HOME="/var/lib/alluxio"
export TACHYON_CONF_DIR="/etc/alluxio/conf"
export TACHYON_LOGS_DIR="/var/log/alluxio"
export TACHYON_DATA_DIR="/var/run/alluxio"
export TACHYON_JAR="\`find $ALLUSIO_LIB_DIR/ -name tachyon*dependencies.jar|grep -v client\`"

# find JAVA_HOME
. /usr/lib/bigtop-utils/bigtop-detect-javahome

if [ -z "JAVA_HOME" ]; then
  export JAVA="/usr/bin/java"
else
  export JAVA="\$JAVA_HOME/bin/java"
fi
EOF

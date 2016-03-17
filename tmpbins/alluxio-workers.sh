#!/usr/bin/env bash

LAUNCHER=
# If debugging is enabled propagate that through to sub-shells
if [[ "$-" == *x* ]]; then
  LAUNCHER="bash -x"
fi

usage="Usage: alluxio-workers.sh command..."

# if no args specified, show usage
if [ $# -le 0 ]; then
  echo $usage
  exit 1
fi

bin=`cd "$( dirname "$0" )"; pwd`
DEFAULT_LIBEXEC_DIR="$bin"/../libexec
ALLUXIO_LIBEXEC_DIR=${ALLUXIO_LIBEXEC_DIR:-$DEFAULT_LIBEXEC_DIR}
. $ALLUXIO_LIBEXEC_DIR/alluxio-config.sh

HOSTLIST=$ALLUXIO_CONF_DIR/workers

for worker in `cat "$HOSTLIST"|sed  "s/#.*$//;/^$/d"`; do
  echo -n "Connection to $worker as $USER... "
  ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -t $worker $LAUNCHER $"${@// /\\ }" 2>&1
  sleep 0.02
done

wait

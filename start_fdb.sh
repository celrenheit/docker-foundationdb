#!/bin/bash

set -m

function wait_for_fdb() {
	echo "Waiting for foundationdb to be ready"
	OUTPUT="something_else"
	while [ "x${OUTPUT}" != "xThe database is available." ]
	do
		OUTPUT=$(fdbcli --exec 'status minimal')
		sleep 2
	done
	echo "FoundationDB is ready"
}

port=${FDB_PORT:-4500}
data_dir=${FDB_DATA_DIR:-/var/lib/foundationdb/data}
log_dir=${FDB_LOG_DIR:-/var/lib/foundationdb/logs}
zoneid=${FDB_ZONE_ID:-"$(hostname)"}
machineid=${FDB_MACHINE_ID:-"$(hostname)"}

knobs=$(printenv | grep FDB_KNOB | sed 's/FDB_KNOB_//g' | tr '[:upper:]' '[:lower:]' | sed 's/^/--knob_/g')

fdbserver 	--listen-address 0.0.0.0:${port} \
			--public-address 127.0.0.1:${port} \
			--datadir ${data_dir} \
			--logdir ${log_dir} \
			--locality-zoneid ${zoneid} \
			--locality-machineid ${machineid} \
			--knob_min_available_space_ratio=0.001 ${knobs} &
export pid=$!
fdbcli --exec 'configure new single ssd'
wait_for_fdb
fg %1
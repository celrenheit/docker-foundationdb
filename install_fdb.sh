#!/bin/bash

set -e

FDB_VERSION=7.3.46
ARCH=$(dpkg --print-architecture)

case "${ARCH}" in
	"arm64")
		FDB_ARCH="aarch64"
		;;
	"aarch64")
		FDB_ARCH="aarch64"
		;;
	"amd64")
		FDB_ARCH="x86_64"
		;;
esac


# case "${FDB_ARCH}" in
# 	"aarch64")
#         FDB_FDBCLI_SHA=
# 		;;
# 	"amd64")
#         FDB_FDBCLI_SHA=
# 		;;
# esac

curl --create-dirs -Lo /usr/lib/libfdb_c.so https://github.com/apple/foundationdb/releases/download/${FDB_VERSION}/libfdb_c.${FDB_ARCH}.so

for binary in fdbcli fdbserver fdbbackup fdbmonitor; do
    curl --create-dirs -Lo /usr/bin/${binary} https://github.com/apple/foundationdb/releases/download/${FDB_VERSION}/${binary}.${FDB_ARCH}
    # echo "${FDB_${binary}_SHA}  /usr/bin/${binary}" | sha256sum -c -
    chmod +x /usr/bin/${binary}
done

echo "docker:docker@127.0.0.1:4500" >/etc/foundationdb/fdb.cluster

# Install the client headers (we download the deb in amd64, not great but it works)
curl --create-dirs -Lo /tmp/fdbclients.deb https://github.com/apple/foundationdb/releases/download/${FDB_VERSION}/foundationdb-clients_${FDB_VERSION}-1_amd64.deb
dpkg -x /tmp/fdbclients.deb /tmp/fdbclients
cp -r /tmp/fdbclients/usr/include/* /usr/include/
rm -rf /tmp/fdbclients /tmp/fdbclients.deb

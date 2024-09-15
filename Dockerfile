FROM ubuntu:22.04 AS server

RUN apt update && \
    apt install -y --no-install-recommends \
    ca-certificates \
    curl && apt-get clean

COPY ./install_fdb.sh /install_fdb.sh

RUN mkdir -p /etc/foundationdb/

RUN /bin/bash /install_fdb.sh

COPY ./start_fdb.sh /start_fdb.sh
RUN mkdir -p /var/lib/foundationdb/logs
CMD ["/bin/bash", "/start_fdb.sh"]
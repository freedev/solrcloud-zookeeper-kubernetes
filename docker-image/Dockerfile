FROM zookeeper:3.4.14

RUN set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        iputils-ping \
        dnsutils \
        net-tools \
        telnet ;\
    rm -rf /var/lib/apt/lists/*; 

COPY docker-entrypoint.sh /

# ENTRYPOINT [ "/custom-entrypoint.sh" ]

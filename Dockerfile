FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wireguard wireguard-tools iptables \
    iproute2 curl tzdata wget build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install udp2raw to tunnel UDP over TCP
RUN wget https://github.com/wangyu-/udp2raw/releases/download/20230206.0/udp2raw_binaries.tar.gz \
    && tar xzf udp2raw_binaries.tar.gz \
    && cp udp2raw_x86 /usr/local/bin/udp2raw \
    && chmod +x /usr/local/bin/udp2raw

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY wg0.conf /etc/wireguard/wg0.conf

EXPOSE 51820/tcp
EXPOSE 51820/udp

ENTRYPOINT ["/entrypoint.sh"]

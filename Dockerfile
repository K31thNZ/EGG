FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN apt-get update && apt-get install -y \
    wireguard \
    wireguard-tools \
    iptables \
    iproute2 \
    curl \
    tzdata \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q https://github.com/wangyu-/udp2raw-tunnel/releases/download/20230206.0/udp2raw_binaries.tar.gz \
    && tar xzf udp2raw_binaries.tar.gz \
    && mv udp2raw_x86 /usr/local/bin/udp2raw \
    && chmod +x /usr/local/bin/udp2raw \
    && rm udp2raw_binaries.tar.gz

RUN mkdir -p /etc/wireguard

COPY start.sh /start.sh
RUN chmod +x /start.sh

COPY wg0.conf /etc/wireguard/wg0.conf

EXPOSE 51820

CMD ["/start.sh"]

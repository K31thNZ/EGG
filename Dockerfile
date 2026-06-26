FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install WireGuard and dependencies
RUN apt-get update && \
    apt-get install -y \
    wireguard \
    wireguard-tools \
    iptables \
    iproute2 \
    curl \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Setup WireGuard config directory
RUN mkdir -p /etc/wireguard

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy WireGuard config
COPY wg0.conf /etc/wireguard/wg0.conf

EXPOSE 51820/udp

ENTRYPOINT ["/entrypoint.sh"]

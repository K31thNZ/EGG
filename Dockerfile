FROM alpine:latest

RUN apk add --no-cache \
    curl \
    bash \
    dante-server

# Configure Dante (SOCKS5 proxy)
RUN echo 'logoutput: stderr' > /etc/sockd.conf && \
    echo 'internal: 0.0.0.0 port = 1080' >> /etc/sockd.conf && \
    echo 'external: eth0' >> /etc/sockd.conf && \
    echo 'socksmethod: username none' >> /etc/sockd.conf && \
    echo 'user.notprivileged: nobody' >> /etc/sockd.conf && \
    echo 'client pass {' >> /etc/sockd.conf && \
    echo '    from: 0.0.0.0/0 to: 0.0.0.0/0' >> /etc/sockd.conf && \
    echo '    log: connect disconnect' >> /etc/sockd.conf && \
    echo '}' >> /etc/sockd.conf && \
    echo 'socks pass {' >> /etc/sockd.conf && \
    echo '    from: 0.0.0.0/0 to: 0.0.0.0/0' >> /etc/sockd.conf && \
    echo '    log: connect disconnect' >> /etc/sockd.conf && \
    echo '}' >> /etc/sockd.conf

EXPOSE 1080

CMD ["sockd", "-f", "/etc/sockd.conf", "-p", "/tmp/sockd.pid", "-N", "2"]

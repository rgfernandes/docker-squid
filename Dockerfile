FROM alpine:3.13

RUN export SQUID_VERSION=4.13 && \
    apk add --no-progress -t build-dependencies \
    file \
    gcc \
    g++ \
    make \
    perl \
    openssl-dev \
    curl && \
    curl http://www.squid-cache.org/Versions/v4/squid-${SQUID_VERSION}.tar.xz -o squid-${SQUID_VERSION}.tar.xz && \
    tar xvfJ squid-${SQUID_VERSION}.tar.xz && \
    cd squid-${SQUID_VERSION} && \
    ./configure --prefix=/opt/squid --sysconfdir=/etc/squid --disable-dependency-tracking \
    --enable-xmalloc-statistics --enable-icmp --enable-delay-pools --enable-auth \
    --enable-auth-basic --enable-auth-digest --enable-auth-negotiate --enable-auth-ntlm \
    --enable-external-acl-helpers --enable-url-rewrite-helpers --enable-security-cert-validators \
    --enable-security-cert-generators --enable-ssl-crtd --with-openssl --disable-ipv6 && \
    make -j 8 && \
    make install && \
    chown nobody:nogroup /opt/squid/var/logs/ && \
    /opt/squid/libexec/security_file_certgen -c -s /opt/squid/var/cache/squid/ssl_db -M 1000 && \
    apk del build-dependencies && \
    apk add libstdc++ && \
    rm -rf /var/cache/apk/* /squid-${SQUID_VERSION}.tar.xz /squid-${SQUID_VERSION}

EXPOSE 3128/tcp

CMD ["/opt/squid/sbin/squid" ]

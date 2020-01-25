FROM debian:buster

RUN apt-get update && \
    apt-get install -y build-essential curl && \
    curl http://www.squid-cache.org/Versions/v4/squid-4.10.tar.xz -o squid-4.10.tar.xz && \
    tar xvfJ squid-4.10.tar.xz && \
    cd squid-4.10 && \
    apt-get install -y libssl-dev && \
    ./configure --prefix=/opt/squid --sysconfdir=/etc/squid --disable-dependency-tracking \
    --enable-xmalloc-statistics --enable-icmp --enable-delay-pools --enable-auth \
    --enable-auth-basic --enable-auth-digest --enable-auth-negotiate --enable-auth-ntlm \
    --enable-external-acl-helpers --enable-url-rewrite-helpers --enable-security-cert-validators \
    --enable-security-cert-generators --enable-ssl-crtd --with-openssl --disable-ipv6 && \
    make -j 8 && \
    make install && \
    apt-get purge -y --autoremove build-essential curl libssl-dev && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* /squid-4.10.tar.xz /squid-4.10


CMD ["/bin/bash" ]

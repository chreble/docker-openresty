FROM phusion/baseimage
MAINTAINER Jonathan Gautheron "jgautheron@nexway.com"

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# define versions
ENV OPENRESTY_VERSION 1.7.4.1
ENV PAGESPEED_VERSION 1.9.32.2-beta

COPY nginx.conf /etc/nginx/nginx.conf
COPY n3_base /etc/nginx/n3_base

RUN apt-get update -qq \
    && apt-get install -yqq build-essential zlib1g-dev libpcre3 libpcre3-dev openssl libssl-dev libperl-dev wget ca-certificates libreadline-dev libncurses5-dev iputils-arping libexpat1-dev wget \
    && (wget -qO - https://github.com/pagespeed/ngx_pagespeed/archive/v${PAGESPEED_VERSION}.tar.gz | tar zxf - -C /tmp) \
    && (wget -qO - https://dl.google.com/dl/page-speed/psol/${PAGESPEED_VERSION}.tar.gz | tar zxf - -C /tmp/ngx_pagespeed-${PAGESPEED_VERSION}/) \
    && (wget -qO - http://openresty.org/download/ngx_openresty-${OPENRESTY_VERSION}.tar.gz | tar zxf - -C /tmp) \
    && ./configure --prefix=/opt/openresty --with-http_gunzip_module --with-luajit \
        --with-luajit-xcflags=-DLUAJIT_ENABLE_CHECKHOOK \
        --http-client-body-temp-path=/var/nginx/client_body_temp \
        --http-proxy-temp-path=/var/nginx/proxy_temp \
        --http-log-path=/var/nginx/access.log \
        --error-log-path=/var/nginx/error.log \
        --pid-path=/var/nginx/nginx.pid \
        --lock-path=/var/nginx/nginx.lock \
        --with-http_stub_status_module \
        --with-http_ssl_module \
        --with-http_realip_module \
        --without-http_fastcgi_module \
        --without-http_uwsgi_module \
        --without-http_scgi_module \
    && make \
    && make install

EXPOSE 443
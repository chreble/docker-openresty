FROM phusion/baseimage
MAINTAINER Jonathan Gautheron "jgautheron@nexway.com"

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Define versions
ENV OPENRESTY_VERSION 1.7.4.1
ENV PAGESPEED_VERSION 1.9.32.2-beta
ENV PAGESPEED_PSOL_VERSION 1.9.32.2
ENV OPENSSL_VERSION 1.0.1j

# Default environment
# Can be overridden at runtime using -e ENVIRONMENT=...
ENV ENVIRONMENT development

# Fix locales
RUN locale-gen en_US.UTF-8 \
    && dpkg-reconfigure locales

RUN apt-get update -qq \
    && apt-get install -yqq build-essential zlib1g-dev libpcre3 libpcre3-dev openssl libssl-dev libperl-dev wget ca-certificates libreadline-dev libncurses5-dev iputils-arping libexpat1-dev wget perl make

RUN (wget -qO - https://github.com/pagespeed/ngx_pagespeed/archive/v${PAGESPEED_VERSION}.tar.gz | tar zxf - -C /tmp) \
    && (wget -qO - https://dl.google.com/dl/page-speed/psol/${PAGESPEED_PSOL_VERSION}.tar.gz | tar zxf - -C /tmp/ngx_pagespeed-${PAGESPEED_VERSION}/) \
    && (wget -qO - http://openresty.org/download/ngx_openresty-${OPENRESTY_VERSION}.tar.gz | tar zxf - -C /tmp) \
    && (wget -qO - https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz | tar zxf - -C /tmp)

RUN cd /tmp/ngx_openresty-${OPENRESTY_VERSION} \
    && ./configure --prefix=/usr/share/nginx \
        --user=www-data \
        --group=www-data \
        --with-luajit \
        --sbin-path=/usr/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-client-body-temp-path=/var/lib/nginx/body \
        --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
        --http-log-path=/var/log/nginx/access.log \
        --http-proxy-temp-path=/var/lib/nginx/proxy \
        --lock-path=/var/lock/nginx.lock \
        --pid-path=/var/run/nginx.pid \
        --with-ipv6 \
        --with-http_ssl_module \
        --with-http_spdy_module \
        --with-openssl=/tmp/openssl-${OPENSSL_VERSION} \
        --with-md5=/tmp/openssl-${OPENSSL_VERSION} \
        --with-md5-asm \
        --with-sha1=/tmp/openssl-${OPENSSL_VERSION} \
        --with-sha1-asm \
        --with-pcre-jit \
        --with-http_stub_status_module \
        --with-http_secure_link_module \
        --with-http_gzip_static_module \
        --with-http_gunzip_module \
        --without-http_uwsgi_module \
        --without-http_scgi_module \
        --without-http_redis_module \
        --without-http_memc_module \
        --without-http_memcached_module \
        --without-http_coolkit_module \
        --without-http_form_input_module \
        --without-http_rds_json_module \
        --without-http_rds_csv_module \
        --without-http_empty_gif_module \
        --without-http_browser_module \
        --without-http_userid_module \
        --without-http_autoindex_module \
        --without-http_geo_module \
        --without-http_split_clients_module \
        --without-mail_pop3_module \
        --without-mail_imap_module \
        --without-mail_smtp_module \
        --without-http_encrypted_session_module \
        --add-module=/tmp/ngx_pagespeed-${PAGESPEED_VERSION} \
    && make \
    && make install

# Cleanup
RUN rm -Rf /tmp/* \
    && apt-get purge -yqq wget build-essential \
    && apt-get autoremove -yqq \
    && apt-get clean all

# Create folders required by nginx & set proper permissions
RUN mkdir /var/lib/nginx 
    && chown -R www-data:www-data /var/lib/nginx \
    && mkdir /var/lib/nginx/proxy \
    && mkdir /var/lib/nginx/body \
    && mkdir /var/lib/nginx/fastcgi \
    && chmod 777 /var/log/nginx

# Add full write permissions to the pagespeed cache folder
RUN mkdir /var/ngx_pagespeed_cache \
    && chmod 777 /var/ngx_pagespeed_cache

# Copy our custom configuration
ADD nginx /etc/nginx/

# Set the proper execution permission on the starting script
RUN chmod +x /etc/nginx/start.sh

# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/var/log/nginx"]

# Define working directory.
WORKDIR /etc/nginx

# Run nginx
CMD ["nginx"]

EXPOSE 443

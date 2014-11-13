Dockerized OpenResty
===============

Optimised and secured SSL-only OpenResty build.
The configuration [follows best practices](https://github.com/h5bp/server-configs-nginx/) in performance and security.

The following modules are enabled:

- luajit
- pcre-jit
- srcache-nginx-module
- array-var-nginx-module
- encrypted-session
- echo-nginx-module
- redis2-nginx-module
- set-misc-nginx-module
- headers-more-nginx-module
- http_stub_status_module
- http_secure_link_module
- http_gzip_static_module
- http_gunzip_module
- http_ssl_module
- http_spdy_module
- pagespeed

### How to use

```bash
# run the container & mount the volumes
docker run -d -p 443:443 \
    -v /etc/nginx/sites-enabled:/etc/nginx/sites-enabled \
    -v /etc/nginx/certs:/etc/nginx/certs \
    -v /etc/nginx/logs:/var/log/nginx \
    --name openresty \
    jgautheron/openresty
```
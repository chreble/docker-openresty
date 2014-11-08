Docker OpenResty for N3
===============

Optimised and secured custom OpenResty build.

The following modules enabled:

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
# first auth on our private registry
docker login https://docker.nexwai.pl # nexway/Nexway2015

# pull the image
docker pull n3-openresty

# run the container & mount the volumes
docker run -d -p 443:443 \
    -v /etc/nexway/nginx/sites-enabled:/etc/nginx/sites-enabled \
    -v /etc/nexway/nginx/certs:/etc/nginx/certs \
    -v /etc/nexway/nginx/logs:/var/log/nginx \
    --name openresty \
    n3-openresty
```

### Development

#### Update the image

```bash
# rebuild it
docker build -t nexway/n3-openresty .

# push it!
docker push docker.nexwai.pl/n3-openresty
```
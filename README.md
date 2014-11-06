Docker OpenResty for N3
===============

Custom OpenResty build with the following modules enabled:

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

##### Build the image

```bash
docker build -t n3-openresty .
```

##### Run the image

```bash
# development, staging or production
docker run -e ENVIRONMENT=development --name test -i -t n3-openresty
```
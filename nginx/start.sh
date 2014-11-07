#!/usr/bin/env bash
ln -s -f /etc/nginx/sites-available/$ENVIRONMENT /etc/nginx/sites-enabled/$ENVIRONMENT
nginx
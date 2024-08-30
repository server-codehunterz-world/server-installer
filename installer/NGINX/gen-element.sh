#!/bin/bash

# Funktion zur Eingabeaufforderung
prompt() {
    read -p "$1: " response
    echo $response
}

server_name=$(prompt "Setup Servername")
root_directory=$(prompt "Setup Root-Directory")
index_file=$(prompt "Setup Index-File (z.B. index.html)")

# NGINX-Konfigurationsdatei erstellen
config_file="/etc/nginx/sites-available/$server_name"

echo "server {
listen 80;
listen [::]:80;
server_name $server_name;
return 301 https://$host$request_uri;
}

server {
listen 443 ssl http2;
listen [::]:443 ssl http2;
server_name $server_name;
root $root_directory;
index index.html;
access_log /var/log/nginx/element.access.log;
error_log /var/log/nginx/element.error.log;

add_header Referrer-Policy "strict-origin" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-Frame-Options "SAMEORIGIN" always;

ssl_certificate /etc/letsencrypt/live/$server_name/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/$server_name/privkey.pem;
ssl_trusted_certificate /etc/letsencrypt/live/$server_name/chain.pem;
ssl_session_timeout 1d;
ssl_session_cache shared:MozSSL:10m;
ssl_session_tickets off;
ssl_prefer_server_ciphers on;
ssl_stapling on;
ssl_stapling_verify on;
ssl_dhparam /etc/ssl/certs/dhparam.pem;

resolver 1.1.1.1 1.0.0.1 [2606:4700:4700::1111] [2606:4700:4700::1001] 8.8.8.8 8.8.4.4 [2001:4860:4860::8888] [2001:4860:4860::8844] valid=60s;
resolver_timeout 2s;
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
}" > $config_file

# Symbolischen Link erstellen
ln -s $config_file /etc/nginx/sites-enabled/

# NGINX neu laden
systemctl reload nginx

echo "Created & Activated NGINX-Configuration for $server_name !..."


sudo cp -r $config_file generated_configs
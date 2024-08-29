#!/bin/bash

# Funktion zur Eingabeaufforderung
prompt() {
    read -p "$1: " response
    echo $response
}

# Benutzerdefinierte Eingaben
server_name=$(prompt "Geben Sie den Servernamen ein")
root_directory=$(prompt "Geben Sie das Root-Verzeichnis ein")
index_file=$(prompt "Geben Sie die Index-Datei ein (z.B. index.html)")

# NGINX-Konfigurationsdatei erstellen
config_file="/etc/nginx/sites-available/$server_name"

echo "server {
    listen 80;
	listen [::]:80;
    server_name $server_name;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name $server_name;

    ssl on;
    ssl_certificate /etc/letsencrypt/live/$server_name/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$server_name/privkey.pem;

    location / {
        proxy_pass http://localhost:8008;
        proxy_set_header X-Forwarded-For $remote_addr;
    }
}

server {
    listen 8448 ssl default_server;
    listen [::]:8448 ssl default_server;
    server_name $server_name;

    ssl on;
    ssl_certificate /etc/letsencrypt/live/$server_name/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$server_name/privkey.pem;
    location / {
        proxy_pass http://localhost:8008;
        proxy_set_header X-Forwarded-For $remote_addr;
    }
}" > $config_file

# Symbolischen Link erstellen
ln -s $config_file /etc/nginx/sites-enabled/

# NGINX neu laden
systemctl reload nginx

echo "Created & Activated NGINX-Configuration for $server_name !..."

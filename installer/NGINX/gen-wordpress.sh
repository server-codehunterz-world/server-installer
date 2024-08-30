#!/bin/bash

# Funktion zur Eingabeaufforderung
prompt() {
    read -p "$1: " response
    echo $response
}

# Benutzerdefinierte Eingaben
server_name=$(prompt "Setup Servername")
root_directory=$(prompt "Setup Root-Directory")
index_file=$(prompt "Setup Index-File (z.B. index.html)")
php_fpm=$(prompt "Set your php-fpm socket i.e php8.2-fpm")

# NGINX-Konfigurationsdatei erstellen
config_file="/etc/nginx/sites-available/$server_name"

echo "server {
    listen 80;
    server_name $server_name;

    root $root_directory;
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php?q=$request_uri;
    }

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_pass unix:/var/run/php/$php_fpm.sock;
        fastcgi_param SCRIPT_FILENAME $request_filename;
        include fastcgi_params;
    }
}
" > $config_file

# Symbolischen Link erstellen
ln -s $config_file /etc/nginx/sites-enabled/

# NGINX neu laden
systemctl reload nginx

echo "Created & Activated NGINX-Configuration for $server_name !..."
sudo cp -r $config_file generated_configs
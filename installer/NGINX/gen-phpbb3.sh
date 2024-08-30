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

echo "# Upstream to abstract backend connection(s) for PHP
upstream phpbb {
    # Path to PHP 8.2 FPM socket, replace this with your own socket path
    server unix:/run/php/$php_fpm.sock;
}

server {
    listen 80;
    listen [::]:80;

 
    # Change this to your specific server name
    server_name $server_name;

    # Replace this with your site root directory
    root $root_directory;
    index index.php index.html index.htm index.nginx-debian.html;

    # Log files, replace these paths if you have different log file paths
    access_log /var/log/nginx/forums-access.log;
    error_log /var/log/nginx/forums-error.log;

    location / {
        try_files $uri $uri/ @rewriteapp;

        # PHP processing, make sure to use your own upstream name if different
        location ~ \.php(/|$) {
            include fastcgi.conf;
            fastcgi_split_path_info ^(.+\.php)(/.*)$;
            fastcgi_param PATH_INFO $fastcgi_path_info;
            fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
            fastcgi_param DOCUMENT_ROOT $realpath_root;
            try_files $uri $uri/ /app.php$is_args$args;
            fastcgi_pass phpbb;
            fastcgi_intercept_errors on;    
        }

        # Deny access to certain PHPBB files
        location ~ /(config\.php|common\.php|cache|files|images/avatars/upload|includes|(?<!ext/)phpbb(?!\w+)|store|vendor) {
            deny all;
            internal;
        }
    }

    location @rewriteapp {
        rewrite ^(.*)$ /app.php/$1 last;
    }

    location /install/ {
        try_files $uri $uri/ @rewrite_installapp =404;

        # PHP processing for installer
        location ~ \.php(/|$) {
            include fastcgi.conf;
            fastcgi_split_path_info ^(.+\.php)(/.*)$;
            fastcgi_param PATH_INFO $fastcgi_path_info;
            fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
            fastcgi_param DOCUMENT_ROOT $realpath_root;
            try_files $uri $uri/ /install/app.php$is_args$args =404;
            fastcgi_pass phpbb;
            fastcgi_intercept_errors on;    
        }
    }

    location @rewrite_installapp {
        rewrite ^(.*)$ /install/app.php/$1 last;
    }

    # Deny access to version control system directories
    location ~ /\.svn|/\.git {
        deny all;
        internal;
    }

    gzip on; 
    gzip_comp_level 6;
    gzip_min_length 1000;
    gzip_proxied any;
    gzip_disable "msie6";

    # Gzip compression types
    gzip_types
        application/atom+xml
        application/geo+json
        application/javascript
        application/x-javascript
        application/json
        application/ld+json
        application/manifest+json
        application/rdf+xml
        application/rss+xml
        application/xhtml+xml
        application/xml
        font/eot
        font/otf
        font/ttf
        image/svg+xml
        text/css
        text/javascript
        text/plain
        text/xml;

    # Static assets, media
    location ~* \.(?:css(\.map)?|js(\.map)?|jpe?g|png|gif|ico|cur|heic|webp|tiff?|mp3|m4a|aac|ogg|midi?|wav|mp4|mov|webm|mpe?g|avi|ogv|flv|wmv)$ {
        expires    90d;
        access_log off;
    }

    # SVG, fonts
    location ~* \.(?:svgz?|ttf|ttc|otf|eot|woff2?)$ {
        add_header Access-Control-Allow-Origin "*";
        expires    90d;
        access_log off;
    }
}" > $config_file

# Symbolischen Link erstellen
ln -s $config_file /etc/nginx/sites-enabled/

# NGINX neu laden
systemctl reload nginx

echo "Created & Activated NGINX-Configuration for $server_name !..."
sudo cp -r $config_file generated_configs
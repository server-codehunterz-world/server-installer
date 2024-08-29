#!/bin/bash
# install.sh

# Author: BlackLeakz
# Website: https://codehunterz.world
# Blog:    https://blog.codehunterz.world
# Board:   https://board.codehunterz.world
# Version: 0.1
# Description: This is a Server Control Panel's installation script to automatically install all server- requirements according to use nginx, phpbb3, wordpress, phpmyadmin on a headless debian-server!"


#######################SETTINGS OF VARIABLES#############################################################

export i="sudo apt-get install -y "
export gc="sudo git clone "



echo -e "Console > Auto Updaing & Upgrading System Now!."
sudo apt-get update 
sudo apt-get upgrade -y 
sudo apt-get dist-upgrade -y 
sudo apt-get autoremove -y 










function build() {
    echo -e "Console > Installing necessary build packages!."
    $i make cmake build-essential sof*prop*c* curl git wget python3-dev python3-pip python3-venv
    $i golang 
    $i clang gcc 
    $i libc6
    $i  libffi-dev python-setuptools sqlite3 libssl-dev python-virtualenv libjpeg-dev libxslt1-dev
    $i apt-transport-https

}

function nginx() {
    echo -e "Console > Installing NGINX-WebServer and Firewall!."
    $i nginx-full ufw fail2ban
    sudo systemctl enable nginx --now
    $i certbot 
    $i python*certbot*nginx
}

function php() {
    echo -e "Console > Installing PHP!."
    $i php*fpm php php*cli php*mysql php*curl php*common php*mbstring php*xml
    $i php*mysql 
    $i php*json 
    $i php*opcache php*gd 
    $i php*bcmath php*soap php*mysqlnd php*intl php*zip
    sudo systemctl enable php8.2-fpm --now
}

function mysql() {
    echo -e "Console > Installing MYSQL Client and Server!."
    $i mariadb-client mariadb-server
    sudo systemctl enable mariadb --now
    
}


function setup_mysql() {
    udo chmod a+x -R MYSQL/setup.sh
    sudo ./MYSQL/setup.sh
}






function phpbb3() {
    echo -e "Console > Installing phpBB3- requirements now!"
    php;
    mysql;
    build;
    nginx;

    echo -e "Console > Start Downloading phpBB3!."
    mkdir -p /var/www/board
    cd /var/www/board
    wget https://downloads.phpbb.de/pakete/deutsch/3.3/3.3.12/phpBB-3.3.12-deutsch.zip
    unzip https://downloads.phpbb.de/pakete/deutsch/3.3/3.3.12/phpBB-3.3.12-deutsch.zip
    cd phpBB*
    mv ./* ../
    cd ..
    rm -rf phpBB3
    cd ..
    chown www-data:www-data -hR /var/www/board
    chmod 755 -R /var/www/board
    
}

function wordpress() {
    echo -e "Console > Installing wordpress now!."
    mkdir -p /var/www/blog/public_html
    
    

    
}


function ufw_firewall() {
    echo -e "Console > Settingup Firewall!."
    $i ufw 
    sudo ufw enable
    sudo ufw allow 80
    sudo ufw allow 80/tcp
    sudo ufw allow 80/udp
    sudo ufw allow 443
    sudo ufw allow 443/tcp
    sudo ufw allow 443/udp
    sudo ufw allow "Nginx FULL"
    sudo ufw allow "Nginx HTTP"
    sudo ufw allow "Nginx HTTPS"
    sudo ufw allow "SSH"
    sudo ufw allow "OpenSSH"
    sudo ufw allow 8008
    sudo ufw allow 8008/tcp
    sudo ufw allow 8008/udp
    sudo ufw allow 8448
    sudo ufw allow 8448/tcp
    sudo ufw allow 8448/udp
    sudo ufw reload
    sudo systemctl enable ufw --now
}


function auto_install() {
    echo -e "Console > Auto-Installing Software!."
    build;
    nginx;
    php;
    mysql;
    ufw_firewall;
}



function manual_install() {
    while true;
    do
    HEIGHT=15
    WIDTH=40
    CHOICE_HEIGHT=4
    TITLE="Server Installer || (c)odehunterz.world"
    MENU="Wählen Sie eine Option:"

    OPTIONS=(1 "Install Build-Dependencies"
             2 "Install WebServer"
             3 "Install PHP"
             4 "Install MYSQL"
             5 "Install UFW Firewall"
             6 "Beenden")

    CHOICE=$(dialog --clear \
                    --backtitle "Linux Shell Script Tutorial" \
                    --title "$TITLE" \
                    --menu "$MENU" \
                    $HEIGHT $WIDTH $CHOICE_HEIGHT \
                    "${OPTIONS[@]}" \
                    2>&1 >/dev/tty)

    clear
    case $CHOICE in
        1)
            echo -e "Console > Start installing build-dependencies!."
            build
            ;;
        2)
            echo -e "Console > Start installing NGINX Webserver!."
            nginx
            ;;
        3) 
            echo -e "Console > Start installing PHP!."
            php
            ;;
        4) 
            echo -e "Console > Start installing MYSQL!."
            mysql
            ;;
        5)
            echo -e "Console > Install UFW Firewall!"
            ufw_firewall
            ;;
        6)
            echo -e "Console > Exiting application!"
            exit
            ;;
    esac
    done 
}





function menu() {
while true;
do
    HEIGHT=15
    WIDTH=40
    CHOICE_HEIGHT=4
    TITLE="Server Installer || (c)odehunterz.world"
    MENU="Wählen Sie eine Option:"

    OPTIONS=(1 "Auto Install requirements"
             2 "Manual Install requirements"
             3 "Install phpBB3"
             4 "Install Wordpress"
             5 "Setup MYSQL"
             6 "Beenden")

    CHOICE=$(dialog --clear \
                    --backtitle "Linux Shell Script Tutorial" \
                    --title "$TITLE" \
                    --menu "$MENU" \
                    $HEIGHT $WIDTH $CHOICE_HEIGHT \
                    "${OPTIONS[@]}" \
                    2>&1 >/dev/tty)

    clear
    case $CHOICE in
        1)
            echo -e "Console > Start installing necessary packages!."
            auto_install
            ;;
        2)
            echo -e "Console > Start manual install!."
            manual_install
            ;;
        3) 
            echo -e "Console > Start installing phpBB3!."
            phpbb3
            ;;
        4) 
            echo -e "Console > Start installing Wordpress!."
            wordpress
            ;;
        5) 
            echo -e "Console > Setup MYSQL!."
            setup_mysql
            ;;
        6)
            echo -e "Console > Exiting application!"
            exit
            ;;
    esac
done 
}



function main() {
    menu;


}



main;
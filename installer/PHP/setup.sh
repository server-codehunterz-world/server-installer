#!/bin/bash
# setup.sh



echo -e "Console > Starting PHP-Setup Guide!..."


function menu() {
    while true;
    do
        HEIGHT=15
        WIDTH=40
        CHOICE_HEIGHT=4
        TITLE="Server Installer || (c)odehunterz.world"
        MENU="Wählen Sie eine Option:"
        
        OPTIONS=(1 "Setup Homepage"
                 2 "Setup phpBB3"
                 3 "Setup Wordpress"
                 4 "Setup"
                 5 "Install UFW Firewall"
                 6 "Beenden")
        
        CHOICE=$(dialog --clear \
            --backtitle "(c)odehunterz.world || Server Installer || PHP-Setup || v0.1a" \
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
                echo -e "Console > Install phpBB3!"
                phpbb3
            ;;
            7)
                echo -e "Console > Install Wordpress!"
                wordpress
            ;;
            8)
                echo -e "Console > Exiting application!"
                exit
            ;;
        esac
    done
}

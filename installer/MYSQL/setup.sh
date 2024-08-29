#!/bin/bash
# setup.sh

# Author: BlackLeakz
# Website: https://codehunterz.world
# Blog:    https://blog.codehunterz.world
# Board:   https://board.codehunterz.world
# Version: 0.1
# Description: This is a Server Control Panel's MYSQL script to automatically setup Db User and Password"

function procedure {
    while true;
    do
        read -p "Database-Name > " DB_NAME
        read -p "Database-User > " DB_USER
        read -p "User-Password > " DB_PASS
        
        # MySQL-Befehle ausführen
        mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
        mysql -u root -p -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
        mysql -u root -p -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
        mysql -u root -p -e "FLUSH PRIVILEGES;"
    done
}


function add_user() {
    while true;
    do
        
        read -p "Database-User > " DB_USER
        read -p "User-Password > " DB_PASS
        
        # MySQL-Befehle ausführen
        mysql -u root -p -e "SHOW DATABASES;"
        read -p "Database-Name > " DB_Name
        mysql -u root -p -e "SELECT DATABASE ${DB_NAME};"
        mysql -u root -p -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
        mysql -u root -p -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
        mysql -u root -p -e "FLUSH PRIVILEGES;"
    done
}


function create_db() {
    while true;
    do
        mysql -u root -p -e "SHOW DATABASES;"
        read -p "Database-Name > " DB_Name
        mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
    done
}


function join_shell() {
    mysql -u root -p
}




function menu() {
    while true;
    do
        HEIGHT=15
        WIDTH=40
        CHOICE_HEIGHT=4
        TITLE="Server Installer || (c)odehunterz.world"
        MENU="Wählen Sie eine Option:"
        
        OPTIONS=(1 "Setup Db, User and Password !"
            2 "Add User !"
            3 "Create Database !"
            4 "Join Interactive MYSQL-Shell !"
        5 "Quit")
        
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
                echo -e "Console > Creating Database & User identified by Password!."
                procedure
            ;;
            2)
                echo -e "Console > Adding User to Database!."
                add_user
            ;;
            3)
                echo -e "Console > Creating Databse only!."
                create_db
            ;;
            4)
                echo -e "Console > Joining Shell!"
                join_shell
            ;;
            5)
                echo -e "Console > Exiting application!"
                exit
            ;;
        esac
    done
}
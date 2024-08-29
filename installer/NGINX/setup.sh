#!/bin/bash
# setup.sh



echo -e "Console > Starting NGINX-Setup Guide!..."


sudo chmod a+x -R ./*
me=$(whoami)
sudo chown $me -hR ./*



function setup_homepage() {
    echo -e "Console > Setting up NGINX-Homepage Config!..."
    sudo ./gen-homepage.sh

}



function setup_phpbb3() {
    echo -e "Console > Setting up PHPBB3-Homepage Config!..."
    sudo ./gen-phpbb3.sh
    
}


function setup_wordpress() {
    echo -e "Console > Setting up WORDPRESS-Homepage Config!..."
    sudo ./gen-wordpress.sh
    
}


function setup_element() {
    echo -e "Console > Setting up ELEMENT-Homepage Config!..."
    sudo ./gen-element.sh
    
}


function setup_matrix() {
    echo -e "Console > Setting up MATRIX-Homepage Config!..."
    sudo ./gen-matrix.sh
    
}


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
                 4 "Setup Element"
                 5 "Setup Matrix"
                 6 "Beenden")
        
        CHOICE=$(dialog --clear \
            --backtitle "(c)odehunterz.world || Server Installer || NGINX-Setup || v0.1a" \
            --title "$TITLE" \
            --menu "$MENU" \
            $HEIGHT $WIDTH $CHOICE_HEIGHT \
            "${OPTIONS[@]}" \
        2>&1 >/dev/tty)
        
        clear
        case $CHOICE in
            1)
                echo -e "Console > Setup Homepage!."
                setup_homepage
            ;;
            2)
                echo -e "Console > Setup phpBB3!."
                setup_phpbb3
            ;;
            3)
                echo -e "Console > Setup Wordpress!."
                setup_wordpress
            ;;
            4)
                echo -e "Console > Setup Element!."
                setup_element
            ;;
            5)
                echo -e "Console > Setup Matrix!."
                setup_matrix
            ;;
            6)
                echo -e "Console > Exiting application!"
                exit
            ;;
        esac
    done
}

#!/bin/bash

function userContainer() {
    vari=$(cat /etc/passwd | awk -F ":" '{print $1}'); counter=0; 
    for t in $vari;do
        users[$counter]=$t;
        counter=$(expr $counter + 1);
    done
        putColors red ${users[$1]};
}

function putColors() {
    if [ $1 = "red" ];then
        red='\033[0;31m';
        noc='\033[0m';
        echo -e ${red} $2 ${noc};
    fi;

    if [ $1 = "blue" ];then
        blue='\033[0;34m';
        noc='\033[0m';
        echo -e ${blue} $2 ${noc};
    fi;

    if [ $1 = "yellow" ];then
        yellow='\033[0;33m';
        noc='\033[0m';
        echo -e ${yellow} $2 ${noc};
    fi;

    if [ $1 = "green" ];then
        green='\033[0;32m';
        noc='\033[0m';
        echo -e ${green} $2 ${noc};
    fi;

    if [ $1 = "cyan" ];then
        cyan='\033[0;36m';
        noc='\033[0m';
        echo -e ${cyan} $2 ${noc};
    fi;

    if [ $1 = "magenta" ];then
        magenta='\033[0;35m';
        noc='\033[0m';
        echo -e ${magenta} $2 ${noc};
    fi;
}

readVar=0;
clear;

while [ $readVar -le 4 ];do
    echo "Introduzca un numero";

    putColors red "1. Linea del usuario";
    putColors green "2. Porcentaje del disco";
    putColors magenta "3. Tamaño de tu home";
    putColors yellow "4. Cantidad de procesos";
    putColors cyan "5. Salir";

    echo -n "Introduzca un valor:";

    read readVar;
    clear;

    case $readVar in
        1)
            clear;
            putColors cyan "introduzca la posicion del arreglo";
            read linea;
            clear;
            echo -n "El usuario en esa posicion es: ";
            userContainer $linea;
            putColors cyan "Presione una tecla para continuar...";
            read;

        ;;

        2)
            clear;
            porcent=$(df -Ph | grep sda1 | awk -F " " '{print $5}');
            putColors green $porcent;
            putColors cyan "Presiona una tecla para continuar...";
            read;
            clear;
        ;;

        3)
            clear;
            espacio=$(du -sh $HOME);
            putColors yellow $espacio;
            putColors cyan "Presione una tecla par continuar...";
            read;
            clear;
        ;;

        4)
            clear;
            procesos=$(ps xau | grep $USER | wc -l);
            putColors magenta $procesos;
            putColors cyan "Presione una tecla par continuar...";
            read;
            clear;
        ;;
        *)
            exit;
        ;;

    esac;

done;








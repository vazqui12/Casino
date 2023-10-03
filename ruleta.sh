#!/bin/bash

# Paleta de Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


# Funcion para cerrar proceso al usar control + c
function ctrl_c(){
    echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
    tput cnorm;
    exit 1
}

# Ctrl+C
trap ctrl_c INT

# Help Panel (el parametro -e sirve para capturar caracteres especiales)
function helpPanel(){
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}${purpleColour} $0${endColour}\n"
    echo -e "\t${purpleColour}m)${endColour}${grayColour} Dinero con el que se desea jugar${endColour}\n"
    echo -e "\t${purpleColour}t)${endColour}${grayColour} Técnica a utilizar${endColour}${purpleColour}(Martingala/inverseLabrouchere)${endColour}\n"
    echo -e "\t${purpleColour}h)${endColour}${grayColour} Mostrando el panel de ayuda${endColour}\n"
}

# Plantilla para declarar funciones
function martingala(){
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual: ${endColour}${yellowColour} $money${endColour}\n"
	echo -ne "\n${yellowColour}[+]${endColour}${grayColour} ¿Cuanto dinero tienes pensado apostar? -> ${endColour}" && read initial_bet
	echo -ne "\n${yellowColour}[+]${endColour}${grayColour} ¿A que deseas apostar continuamente (par/impar) -> ${endColour}" && read par_impar

	echo -e "\n${yellowColour}[+]${endColour}${grayColour} Vamos a jugar con una cantidad inicial de ${endColour}${yellowColour} $initial_bet${endColour}${grayColour} a${endColour}${yellowColour} $par_impar${endColour}\n"

    backup_bet=$initial_bet
    play_counter=1
    jugadas_malas="[ "

    tput civis
    while true; do
		$money=$(($money-$initial_bet))
        random_number="$(($RANDOM % 37))" #usamos $RANDOM para generar un numero aletario y ponemos hasta 37 que es el rango de numero que hay en la ruleta, por tanto, queremos que saque numeros entre el 0 y el 36
		
#       echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ha salido el numero ${endColour}${purpleColour} $random_number${endColour}\n"
        if [ ! "$money" -le 0 ]; then
            if [ "$par_impar" == "par" ]; then
                if [ "$(($random_number % 2))" -eq 0 ]; then
                    if [ "$random_number" -eq 0 ]; then
                        initial_bet=$(($initial_bet*2))
                        jugadas_malas="$random_number"
#                       echo -e "\n${yellowColour}[+]${endColour}${grayColour} El numero que ha salido 0, por tanto, perdemos${endColour}\n"
                    else
#                       echo -e "\n${yellowColour}[+]${endColour}${grayColour} El numero que ha salido es par${endColour}\n"
                        reward=$(($initial_bet*2))
                        money=$(($money+$reward))
                        initial_bet=$backup_bet
                        jugadas_malas=""
                    fi
                else
#                       echo -e "\n${yellowColour}[+]${endColour}${grayColour} El numero que ha salido es impar${endColour}\n"
                        initial_bet=$(($initial_bet*2))
                        jugadas_malas="$random_number"
                fi
            fi
        else
            echo -e "\n${redColour}[!] Te has quedado sin pasta cabron${endColour}\n"
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ha habido un total de ${endColour}${yellowColour}$play_counter${endColour}${grayColour} jugadas${endColour}\n"
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} A continuación se van a representar las malas jugadas consecuticas que han salido:${endColour}\n"
            echo -e "\n${yellowColour}$jugadas_malas${endColour}\n"
            
            tput cnorm; 
            exit 0
        fi

        let play_counter+=1

    done

    tput cnorm
}



# Menú
# m tiene : porque se espera que se proporcione un argumento siempre que se use -m. Con -h no es necesario
# especificar argumento. La variable arg contiene el valor de la opcion actual que ha sido analizada por
# getopts.
while getopts "m:t:h" arg; do
    case $arg in
        m) money="$OPTARG";;
		t) technique="$OPTARG";;
        h) helpPanel;; # Para cada sentencia hay que poner ;; para cerrarla
    esac
done


# Sección para llamar a las distintas funciones acorde a cada opción
if [ $money ] && [ $technique ]; then 
    if [ "$technique" == "martingala" ]; then
		martingala
    else
		echo -e "\n${redColour}[!] La técnica introducida no es correcta${endColour}\n"
		helpPanel
    fi
else
	echo -e "\n${redColour}[!] Los datos introducidos son incorrectos${endColour}\n"
    helpPanel
fi


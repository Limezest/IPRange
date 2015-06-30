#!/bin/bash
clear

network_bytes=10.7

function ouistiti {
    echo
	bool="false"
	while [ $bool == "false"  ]
	do
	    read -p "Lequel ? " host
		case $host in
			[0-9]*) bool=$true break;;
			*) echo "Rentrez un nombre";;
		esac
	done
	echo "Connecting to > $network_bytes.$salle.$host"
    echo ""
    read -p "Username: " login

    ssh -c blowfish -X -Y -C -t -t $login@$network_bytes.$salle.$host << EOF
      who
EOF
}

function menu {
	bool="false"
	while [ $bool == "false" ]
	do
		echo
		echo "1. SSH"
		echo "2. nmap"
		echo "0. Exit"
	
		stty -echo
		read -n 1 -p "" menuAnswer
		stty echo

		case $menuAnswer in
			1|\&) bool=$true ouistiti;;
			2|é) bool=$true nmapScan;;
			q|Q|0|à) exit 0;;
			*) echo "Choississez une reponse";;
		esac
	done
}

function nmapScan {
	echo
	bool="false"
	while [ $bool == "false" ]
	do
		read -p "Lequel ? " host
		case $host in
			[0-9]*) bool=$true break;;
			*) echo "Rentrez un nombre";;
		esac
	done
	echo "Scanning for > $network_bytes.$salle.$host"
	echo

	nmap -A -T4 $network_bytes.$salle.$host
}


# Init {
	salle=-1
	ip=-1
	fast=1

	if [ $# == 3 ]
	then
	    salle=$1
	    ip=$2
	    fast=$3
	else
	    while [ $salle -lt 0 ] || [ $salle -ge 255 ]
	    do
	         read -p "Quelle salle ? " salle
	    done

	    read -p "Combien d'ip ? " ip
	    read -n 1 -p "Scan rapide ? [1/0] " fast
	fi

	timeout_var=0.5s
	if [ "$fast" == "1" ]
	then
		timeout_var=0.05s
	fi
#}
    
function main {
    i=1
    u=0
    while [ $i -le $ip ]
    do
      echo -ne " $i / $ip \r"
      timeout $timeout_var ping $network_bytes.$salle.$i -c 1 > /dev/null
      if [ $? -eq 0 ]; then 
        table[${#table[*]}+1]="$network_bytes.$salle.$i"
      fi
      i=$(($i+1))
    done

    if [ ${#table[*]} == 0 ]
    then
		echo "Aucun périphérique trouvé entre $network_bytes.$salle.1 et $network_bytes.$salle.$ip"
    else
		echo "+------------+"

	    for line in ${table[*]}
	    do
	          echo "| $line"
	    done
		echo "+------------+"

		echo
		if [ ${#table[*]} == 0 ] || [ ${#table[*]} == 1  ]; then s=""; else s="s";fi
		echo "> ${#table[*]} appareil$s trouvé$s"
		echo "[ENTRÉE] pour continuer"
		read

		menu
		exit 0;

#	    bool="false"
#	    echo "Souhaitez-vous vous connecter en ssh sur un des ${#table[*]} PCs ? [Y/n] "
#	    while [ $bool == "false" ]
#	    do
#	              read -n 1 result
#	              case $result in
#	                  y|Y|"") bool=$true ouistiti ;;
#	                  n|N) exit 0;;
#	                  *) echo " Répondez par y ou n";;
#	              esac
#	    done
    fi
}

# init
main

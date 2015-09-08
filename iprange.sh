#!/bin/bash

source ./var.sh
source ./usage.sh


#  ----------------------------------------------------------------------------

# Init {
    #  Settings parameters
	salle=-1
	ip=-1
	fast=-1
	timeout_var=0.05s  #  default fast scan

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

	    while [ $ip -lt 0 ] || [ $ip -ge 255 ]
	    do
	         read -p "Combien d'ip ? " ip
	    done

	    while [ $fast -ne 0 ] || [ $fast -ne 1 ]
	    do
	         read -n 1 -p "Scan rapide ? [1/0] " fast
	    done
	fi

	if [ "$fast" == "0" ]
	then
		timeout_var=0.5s
	fi
#}

function main {
	clear

    i=1
    u=0

	#  Scanning
    while [ $i -le $ip ]
    do
      echo -ne " $i / $ip \r"
      timeout $timeout_var ping $network_bytes.$salle.$i -c 1 > /dev/null

      if [ $? -eq 0 ]; then  # if answer code; then store it
        table[${#table[*]}+1]="$network_bytes.$salle.$i"
      fi

      i=$(($i+1))
    done

	#  Display results
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

    fi
}


#  ----------------------------------------------------------------------------


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
			1|\&) bool=$true SSHconnect;;
			2|é) bool=$true nmapScan;;
			q|Q|0|à) exit 0;;
			*) echo "Choississez une reponse";;
		esac
	done
}


function SSHconnect {
    echo
	bool="false"

	while [ $bool == "false"  ]
	do
	    read -p "Lequel ? " host
		case $host in
			[0-9]*) bool=$true break;;
			*)		echo "Rentrez un nombre";;
		esac
	done

	echo "Connecting to > $network_bytes.$salle.$host"
    echo ""
    read -p "Username: " login

    ssh -c blowfish -X -Y -C -t -t $login@$network_bytes.$salle.$host << EOF
      who
EOF
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

#  ----------------------------------------------------------------------------

# init
main

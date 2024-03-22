#! /bin/bash
echo welcomeback boss
echo "
██████╗ ███████╗███╗   ██╗████████╗███████╗███████╗████████╗    ██╗████████╗
██╔══██╗██╔════╝████╗  ██║╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝    ██║╚══██╔══╝
██████╔╝█████╗  ██╔██╗ ██║   ██║   █████╗  ███████╗   ██║       ██║   ██║
██╔═══╝ ██╔══╝  ██║╚██╗██║   ██║   ██╔══╝  ╚════██║   ██║       ██║   ██║
██║     ███████╗██║ ╚████║   ██║   ███████╗███████║   ██║       ██║   ██║
╚═╝     ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚══════╝   ╚═╝       ╚═╝   ╚═╝
				        -  _T () ~|~ |-| [- [- _\~ \/\/ /\ /?"


# Check if running as root
if [ "$(id -u)" != "0" ]; then
    echo "This script requires root privileges. Please run it with sudo."
    exit 1
fi


echo "CHOOSE OPTIONS:"
echo "1:Reconissiance"
echo "2:Vuln Assesment"
echo "3:Exploitation"
echo "4:Persistence"
echo "5:privilege Escalation"
echo "Exit"

read option

if [[ $option == "1" ]]; then
	./nmap.sh
fi

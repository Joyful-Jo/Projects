#!/bin/bash

# Function for performing active reconnaissance
active_recon() {
    echo "Performing active reconnaissance..."
    read -p "Enter the target domain or IP address: " target

    echo "Choose tools for active reconnaissance:"
    echo "1. Nmap"
    echo "2. Masscan"
    echo "3. EyeWitness"
    echo "4. Nikto"
    echo "5. Wafw00f"
    read -p "Choose tools (comma-separated list): " active_tools

    IFS=',' read -ra tools <<< "$active_tools"

    for tool in "${tools[@]}"; do
        case $tool in
            1)
                echo "Running Nmap scan..."
                nmap -sV -O $target
                ;;
            2)
                echo "Running Masscan scan..."
                masscan $target -p1-65535
                ;;
            3)
                echo "Running EyeWitness..."
                eyeWitness -f $target --active-scan
                ;;
            4)
                echo "Running Nikto..."
                nikto -h $target
                ;;
            5)
                echo "Running Wafw00f..."
                wafw00f $target
                ;;
            *)
                echo "Invalid tool option: $tool"
                ;;
        esac
    done
}

# Function for performing passive reconnaissance
passive_recon() {
    echo "Performing passive reconnaissance..."
    read -p "Enter the target domain: " domain

    echo "Choose tools for passive reconnaissance:"
    echo "1. Whois"
    echo "2. Shodan"
    echo "3. Recon-ng"
    echo "4. Sublist3r"
    echo "5. theHarvester"
    read -p "Choose tools (comma-separated list): " passive_tools

    IFS=',' read -ra tools <<< "$passive_tools"

    for tool in "${tools[@]}"; do
        case $tool in
            1)
                echo "Performing WHOIS lookup..."
                whois $domain
                ;;
            2)
                echo "Running Shodan search..."
                shodan search $domain
                ;;
            3)
                echo "Running Recon-ng..."
                recon-ng -m recon/domains-hosts/brute_hosts -c "options set SOURCE $domain; run"
                ;;
            4)
                echo "Running Sublist3r..."
                python sublist3r.py -d $domain
                ;;
            5)
                echo "Running theHarvester..."
                theharvester -d $domain -l 500 -b google
                ;;
            *)
                echo "Invalid tool option: $tool"
                ;;
        esac
    done
}

# Main menu
echo "Welcome to the Reconnaissance Tool"
echo "1. Active Reconnaissance"
echo "2. Passive Reconnaissance"
echo "3. Exit"

read -p "Choose an option: " option

case $option in
    1)
        active_recon
        ;;
    2)
        passive_recon
        ;;
    3)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid option. Exiting..."
        exit 1
        ;;
esac


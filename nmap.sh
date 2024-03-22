#!/bin/bash

# Function for performing Nmap scan
perform_nmap_scan() {
    read -p "Enter target(s) (IP address(es) or domain name(s)): " targets
    read -p "Enter scan type (TCP SYN scan: -sS, TCP connect scan: -sT, UDP scan: -sU): " scan_type
    read -p "Enter additional options (comma-separated, e.g., -Pn,-p1-65535,-A): " additional_options
    read -p "Enable service version detection? (y/n): " version_detection
    read -p "Enable OS detection? (y/n): " os_detection

    # Enable script scanning
    read -p "Enable script scanning? (y/n): " script_scan
    if [[ $script_scan == "y" ]]; then
        read -p $'Enter Nmap script(s) (comma-separated):\n\nAvailable examples:\n\nvuln\nhttp-enum\nftp-anon\nssh-brute\nsmtp-enum-users\nsmb-vuln-ms17-010\ndns-zone-transfer\nsnmp-brute\nssl-heartbleed\nimap-ntlm-info\nmysql-empty-password\nredis-info\nmongodb-info\noracle-sid-brute\nx11-access\nrpcinfo\n\nExample input: vuln,http-enum\n\n' nmap_scripts
        nmap_command+=" --script=$nmap_scripts"
    fi

    # Construct Nmap command
    nmap_command="nmap $scan_type $additional_options"

    if [[ $version_detection == "y" ]]; then
        nmap_command+=" -sV"
    fi

    if [[ $os_detection == "y" ]]; then
        nmap_command+=" -O"
    fi

    read -p "Enable aggressive scanning? (y/n): " aggressive_scan
    if [[ $aggressive_scan == "y" ]]; then
        nmap_command+=" -T4 -A"
    fi

    # Enable output to file
    read -p "Enable output to file? (y/n): " output_to_file
    if [[ $output_to_file == "y" ]]; then
        read -p "Enter output file path (or leave empty for default): " output_file
        if [ -z "$output_file" ]; then
            output_file="nmap_scan_$(date '+%Y%m%d_%H%M%S').txt"
        fi
        nmap_command+=" -oN $output_file"
    fi

    read -p "Enable verbose output? (y/n): " verbose_output
    if [[ $verbose_output == "y" ]]; then
        nmap_command+=" -v"
    fi

    read -p "Enable timing template? (y/n): " timing_template
    if [[ $timing_template == "y" ]]; then
        read -p "Choose timing template (1-5, where 1 is the slowest and 5 is the fastest): " timing
        nmap_command+=" -T$timing"
    fi

    read -p "Enable ICMP ping? (y/n): " icmp_ping
    if [[ $icmp_ping == "y" ]]; then
        nmap_command+=" -PE"
    fi

    nmap_command+=" $targets"

    echo "Running Nmap scan with command: $nmap_command"
    eval "$nmap_command"
}

# Main function
main() {
    echo "Welcome to the Nmap Scanner"
    perform_nmap_scan
}

# Execute main function
main

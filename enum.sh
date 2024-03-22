#!/bin/bash

# Function to parse Nmap output and identify vulnerabilities
parse_nmap_output() {
    # Check if an argument (output file path) is provided
    if [ $# -eq 0 ]; then
        echo "Usage: $0 <output_file>"
        exit 1
    fi

    output_file="$1"

    # Check if the output file exists
    if [ ! -f "$output_file" ]; then
        echo "Error: File '$output_file' not found."
        exit 1
    fi

    # Parse Nmap output to extract open ports and service versions
    echo "Parsing Nmap output file..."
    open_ports=$(awk '/^Nmap scan report for/{print $5}' "$output_file")
    service_versions=$(awk '/open/{print $3 " " $5}' "$output_file")

    # Loop through open ports and service versions to identify potential vulnerabilities
    echo "Identifying potential vulnerabilities..."
    for port in $open_ports; do
        echo "Open Port: $port"
        echo "-----------------------------"
        echo "Service Versions:"
        echo "$service_versions" | grep "$port/tcp" | while read line; do
            service=$(echo "$line" | awk '{print $1}')
            version=$(echo "$line" | awk '{print $2}')
            echo "Service: $service, Version: $version"
            # Use nmap-vulners script to check for vulnerabilities
            echo "Checking for vulnerabilities using nmap-vulners script..."
            nmap --script vulners -p $port $service >/dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo "Vulnerabilities found:"
                nmap --script vulners -p $port $service
            else
                echo "No vulnerabilities found using nmap-vulners script."
            fi
            # Check for known vulnerabilities using searchsploit
            echo "Checking for known vulnerabilities using searchsploit..."
            searchsploit -w "$service $version"
            echo "-----------------------------"
        done
    done
}

# Function to provide enumeration options
provide_enumeration_options() {
    # Provide options for enumeration
    echo "Enumeration Options:"
    echo "1. Perform manual enumeration (e.g., banner grabbing, service enumeration)"
    echo "2. Exit"
}

# Main function
main() {
    echo "Welcome to the Pentesting Enumeration Tool"

    # Take output file path as input
    read -p "Enter the path to the Nmap output file: " output_file

    # Parse Nmap output and identify vulnerabilities
    parse_nmap_output "$output_file"

    # Provide enumeration options
    provide_enumeration_options

    # Prompt user for choice
    read -p "Enter your choice (1-2): " choice

    # Execute chosen option
    case $choice in
        1) echo "Performing manual enumeration..."
           # Add your code to perform manual enumeration here
           ;;
        2) echo "Exiting the Pentesting Enumeration Tool. Goodbye!"
           exit 0
           ;;
        *) echo "Invalid choice. Exiting..."
           exit 1
           ;;
    esac
}

# Execute main function
main


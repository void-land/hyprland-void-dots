#!/bin/bash

declare -A dns_servers=(
    ["Google"]="8.8.8.8,8.8.4.4"
    ["Cloudflare"]="1.1.1.1"
    ["403"]="10.202.10.202,10.202.10.102"
    ["Shecan"]="178.22.122.100,185.51.200.2"
)

display_dns_list() {
    echo "Available DNS Servers:"
    i=1
    for dns_name in "${!dns_servers[@]}"; do
        echo "$i. ${dns_name}"
        ((i++))
    done
}

select_dns() {
    read -p "Select a DNS server (enter the name or number): " selected_input

    if [[ $selected_input =~ ^[0-9]+$ ]]; then
        if ((selected_input >= 1 && selected_input <= ${#dns_servers[@]})); then
            selected_name=$(echo "${!dns_servers[@]}" | cut -d ' ' -f $selected_input)
            selected_dns=${dns_servers[$selected_name]}
            echo "Selected DNS server: $selected_dns"
        else
            echo "Invalid number. Please select a valid number."
            select_dns
        fi
    else
        if [[ -n ${dns_servers[$selected_input]} ]]; then
            selected_dns=${dns_servers[$selected_input]}
            echo "Selected DNS server: $selected_dns"
        else
            echo "Invalid name. Please select a valid name."
            select_dns
        fi
    fi
}

update_resolv_conf() {
    sudo sh -c "echo '' > /etc/resolv.conf"
    IFS=',' read -ra dns_array <<<"$1"
    for dns in "${dns_array[@]}"; do
        echo "nameserver $dns" | sudo tee -a /etc/resolv.conf >/dev/null
    done
    echo "Updated /etc/resolv.conf with DNS servers: $1"
}

display_dns_list
select_dns
update_resolv_conf "$selected_dns"

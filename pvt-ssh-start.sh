#!/bin/bash

# Start the ssh-agent and add keys to it
eval "$(ssh-agent -s)"

# Add all SSH keys (excluding .pub files)
for key in ~/.ssh/*; do
    # Skip public keys, config file, and other non-key files
    if [[ -f "$key" && ! "$key" == *.pub && ! "$(basename "$key")" == "config" && ! "$(basename "$key")" == "known_hosts" ]]; then
        echo "Adding key: $key"
        chmod 600 "$key"
        ssh-add "$key"
    fi
done

# List the keys added to the SSH agent
ssh-add -l
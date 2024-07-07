#!/bin/bash

# Start the ssh-agent and add keys to it
eval "$(ssh-agent -s)"

# Iterate over all files in the .ssh directory
for key in ~/.ssh/*; do
    # Extract the base name of the file
    filename=$(basename -- "$key")
    # Check if the file is readable, not a directory, does not have a dot in the filename, and has a corresponding public key file
    if [[ -f "$key" && -r "$key" && "$filename" != *.* && -f "$key.pub" ]]; then
        echo "Processing key: $key"
        chmod 600 "$key"
        ssh-add "$key"
    fi
done

# List the keys added to the SSH agent
ssh-add -l

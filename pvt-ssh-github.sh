#!/bin/bash

# Prompt the user for input
read -p "Enter your email address: " EMAIL
read -p "Enter a name for your SSH key (without spaces): " KEY_NAME
read -p "Enter your GitHub username: " GITHUB_USERNAME
read -p "Enter the repository name: " REPO_NAME

# Variables
KEY_PATH="$HOME/.ssh/$KEY_NAME"
CONFIG_FILE="$HOME/.ssh/config"

# Generate a new SSH key
ssh-keygen -t rsa -b 4096 -C "$EMAIL" -f "$KEY_PATH" -N ""

# Start the ssh-agent
eval "$(ssh-agent -s)"

# Add the new SSH key to the ssh-agent
ssh-add "$KEY_PATH"

# Add the new SSH key to the SSH config file
if [ ! -f "$CONFIG_FILE" ]; then
    touch "$CONFIG_FILE"
fi

if ! grep -q "Host github-$KEY_NAME" "$CONFIG_FILE"; then
    echo "Adding new SSH key configuration to $CONFIG_FILE"
    cat <<EOL >> "$CONFIG_FILE"

# Configuration for $KEY_NAME
Host github-$KEY_NAME
  HostName github.com
  User git
  IdentityFile $KEY_PATH
EOL
else
    echo "SSH key configuration for $KEY_NAME already exists in $CONFIG_FILE"
fi

# Display the public key and instructions to add it to GitHub
echo "SSH key generated and configured. Add the following public key to your GitHub account:"
cat "$KEY_PATH.pub"
echo ""
echo "To add the key to your GitHub account, follow these steps:"
echo "1. Go to https://github.com and log in."
echo "2. Navigate to Settings > SSH and GPG keys."
echo "3. Click on New SSH key."
echo "4. Provide a title for the key (e.g., 'Ubuntu Server Key')."
echo "5. Paste the key below into the 'Key' field and click Add SSH key."
echo ""
echo "To clone the repository using this new key, use the following command:"
echo "git clone git@github-$KEY_NAME:$GITHUB_USERNAME/$REPO_NAME.git"

# Provide instructions for setting up SSH keys in .bashrc
echo ""
echo "To ensure your SSH keys are loaded automatically, add the following lines to your ~/.bashrc file:"
echo "eval \"\$(ssh-agent -s)\""
echo "for key in ~/.ssh/id_* ~/.ssh/*_key; do"
echo "    if [ -f \"\$key\" ] && [ -r \"\$key\" ]; then"
echo "        if [[ \"\$key\" != *.pub ]]; then"
echo "            chmod 600 \"\$key\""
echo "            ssh-add \"\$key\""
echo "        fi"
echo "    fi"
echo "done"

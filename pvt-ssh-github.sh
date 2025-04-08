#!/bin/bash

# Prompt the user for input
read -p "Enter your email address: " EMAIL
read -p "Enter your GitHub username: " GITHUB_USERNAME
read -p "Enter the repository name: " REPO_NAME

# Automatically generate key name based on the repository name
KEY_NAME="github-${REPO_NAME}"
echo "Using SSH key name: $KEY_NAME"

# Variables
KEY_PATH="$HOME/.ssh/$KEY_NAME"
CONFIG_FILE="$HOME/.ssh/config"

# Create .ssh directory if it doesn't exist
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Generate a new SSH key
ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_PATH" -N ""

# Start the ssh-agent
eval "$(ssh-agent -s)"

# Add the new SSH key to the ssh-agent
chmod 600 "$KEY_PATH"
ssh-add "$KEY_PATH"

# Add the new SSH key to the SSH config file
if [ ! -f "$CONFIG_FILE" ]; then
    touch "$CONFIG_FILE"
    chmod 600 "$CONFIG_FILE"
fi

if ! grep -q "Host github-$KEY_NAME" "$CONFIG_FILE"; then
    echo "Adding new SSH key configuration to $CONFIG_FILE"
    cat <<EOL >> "$CONFIG_FILE"

# Configuration for $KEY_NAME
Host github-$KEY_NAME
  HostName github.com
  User git
  IdentityFile $KEY_PATH
  AddKeysToAgent yes
  IdentitiesOnly yes
EOL
else
    echo "SSH key configuration for $KEY_NAME already exists in $CONFIG_FILE"
fi

# Display the public key and instructions to add it to GitHub
echo ""
echo "================================================================================"
echo "SSH key generated and configured. Add the following public key to your GitHub account:"
echo "================================================================================"
echo ""
cat "$KEY_PATH.pub"
echo ""
echo "================================================================================"
echo "To add the key to your GitHub account, follow these steps:"
echo "1. Go to https://github.com and log in."
echo "2. Navigate to Settings > SSH and GPG keys."
echo "3. Click on New SSH key."
echo "4. Provide a title for the key (e.g., 'Ubuntu Server Key')."
echo "5. Paste the key above into the 'Key' field and click Add SSH key."
echo ""
echo "To clone the repository using this new key, use the following command:"
echo "git clone git@github-$KEY_NAME:$GITHUB_USERNAME/$REPO_NAME.git"
echo "================================================================================"

# Create the auto-loading script
cat > "$HOME/pvt-ssh-start.sh" << 'EOF'
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
EOF

chmod +x "$HOME/pvt-ssh-start.sh"

# Provide instructions for setting up SSH keys in .bashrc
echo ""
echo "================================================================================"
echo "Would you like to automatically update your ~/.bashrc file to load SSH keys on login? (y/n)"
read -p "> " UPDATE_BASHRC

if [[ "$UPDATE_BASHRC" == "y" || "$UPDATE_BASHRC" == "Y" ]]; then
    # Check if the lines already exist in .bashrc
    if ! grep -q "pvt-ssh-start.sh" ~/.bashrc; then
        echo "" >> ~/.bashrc
        echo "# Start SSH agent and load keys" >> ~/.bashrc
        echo "if [ -f \"\$HOME/pvt-ssh-start.sh\" ]; then" >> ~/.bashrc
        echo "    \"\$HOME/pvt-ssh-start.sh\"" >> ~/.bashrc
        echo "fi" >> ~/.bashrc
        
        echo "~/.bashrc has been updated. Your SSH keys will now be loaded automatically on login."
        echo "To apply changes to your current session, run: source ~/.bashrc"
    else
        echo "The necessary lines already exist in your ~/.bashrc file."
    fi
else
    echo "To ensure your SSH keys are loaded automatically, add the following lines to your ~/.bashrc file:"
    echo ""
    echo "# Start SSH agent and load keys"
    echo "if [ -f \"\$HOME/pvt-ssh-start.sh\" ]; then"
    echo "    \"\$HOME/pvt-ssh-start.sh\""
    echo "fi"
    echo ""
    echo "You can add these lines by running:"
    echo "echo '# Start SSH agent and load keys' >> ~/.bashrc"
    echo "echo 'if [ -f \"\$HOME/pvt-ssh-start.sh\" ]; then' >> ~/.bashrc"
    echo "echo '    \"\$HOME/pvt-ssh-start.sh\"' >> ~/.bashrc"
    echo "echo 'fi' >> ~/.bashrc"
    echo ""
    echo "Then apply the changes with: source ~/.bashrc"
fi
echo "================================================================================"
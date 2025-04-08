# SSH Key Setup for GitHub Repositories

This script helps you generate an SSH key, configure your SSH client, and add the key to your GitHub account for seamless repository cloning and management.

## Usage

1. **Download the Script**

   Save the script as `pvt-ssh-github.sh`.

2. **Make the Script Executable**

   Run the following command to make the script executable:

   ```sh
   chmod +x pvt-ssh-github.sh
   ```

3. **Run the Script**

   Execute the script to generate and configure your SSH key:

   ```sh
   ./pvt-ssh-github.sh
   ```

   The script will prompt you for the following information:

   - Your email address
   - Your GitHub username
   - The repository name

   The SSH key name will be automatically generated based on the repository name.

4. **Add the SSH Key to GitHub**

   After running the script, you will see instructions to add your new SSH public key to your GitHub account:

   1. Copy the displayed public key.
   2. Go to [GitHub](https://github.com) and log in.
   3. Navigate to **Settings** > **SSH and GPG keys**.
   4. Click on **New SSH key**.
   5. Provide a title for the key (e.g., "Ubuntu Server Key").
   6. Paste the copied key into the "Key" field and click **Add SSH key**.

5. **Test the SSH Key**

   To test the SSH key and ensure it is correctly added to your GitHub account, run:

   ```sh
   ssh -T git@github.com
   ```

   You should see a message saying you've successfully authenticated.

6. **Clone the Repository**

   Use the provided command to clone your repository with the new SSH key:

   ```sh
   git clone git@github-<KEY_NAME>:<GITHUB_USERNAME>/<REPO_NAME>.git
   ```

   Replace `<KEY_NAME>`, `<GITHUB_USERNAME>`, and `<REPO_NAME>` with the values you provided during the script execution.

## Ensuring SSH Keys are Loaded Automatically

The script will create a helper script called `pvt-ssh-start.sh` in your home directory and will ask if you want to automatically update your `~/.bashrc` file to load your SSH keys at login.

If you choose not to automatically update your `~/.bashrc`, you can manually add these lines:

```sh
# Start SSH agent and load keys
if [ -f "$HOME/pvt-ssh-start.sh" ]; then
    "$HOME/pvt-ssh-start.sh"
fi
```

After updating your `~/.bashrc` file, apply the changes by running:

```sh
source ~/.bashrc
```

## Features of the Setup

- Generates an Ed25519 SSH key (more secure than RSA)
- Properly configures SSH with the correct permissions
- Sets up a dedicated Host entry for GitHub to avoid SSH key conflicts
- Creates a helper script to automatically load keys at login
- Ensures proper file permissions for security

This setup provides all the necessary components for generating and using SSH keys with GitHub, ensuring a smooth and secure setup process.

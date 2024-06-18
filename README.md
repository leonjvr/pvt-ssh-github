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
   - A name for your SSH key (without spaces)
   - Your GitHub username
   - The repository name

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

To ensure your SSH keys are loaded automatically when you start a new session, add the following lines to your `~/.bashrc` file:

```sh
# Start the ssh-agent
eval "$(ssh-agent -s)"

# Add all SSH keys
for key in ~/.ssh/id_* ~/.ssh/*_key; do
    if [ -f "$key" ] && [ -r "$key" ]; then
        if [[ "$key" != *.pub ]]; then
            chmod 600 "$key"
            ssh-add "$key"
        fi
    fi
done
```

You can add these lines by editing your `~/.bashrc` file:

```sh
nano ~/.bashrc
```

Then paste the lines at the end of the file and save it.

After updating your `~/.bashrc` file, apply the changes by running:

```sh
source ~/.bashrc
```

This README provides all the necessary instructions for generating and using SSH keys with GitHub, ensuring a smooth setup process.

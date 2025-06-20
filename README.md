# 🛠️ GitHub Repo Migration Script

This script automates the migration of multiple local Git repositories to GitHub using SSH and the GitHub CLI (`gh`). It handles:

- SSH key setup  
- Repository existence checks  
- Remote creation and linking  
- Pushing all branches and tags  

---

## 📁 Project Structure

This script expects the following:

- Your local repositories are stored under a common base directory
- You have a GitHub account with SSH access configured  
- `gh` CLI is authenticated and available in your environment  

---

## 🔧 Configuration

Before running the script, update the following variables in the script:

```bash
BASE_DIR="/your/local/path"              # Path to your local repositories
GITHUB_HOST="github.com"                 # GitHub host (or SSH alias if used)
GITHUB_ORG="github-username"             # Your GitHub username or organization
SSH_KEY="~/.ssh/id_rsa"         # SSH key to use for authentication
```
Then, populate the REPOS array with the names of your local repositories:

```
REPOS=(
    "project_one"
    "project_two"
    "project_three"
    "project_four"
)
```

## 🔐 Setting Up SSH Keys

If you haven't created and added an SSH key to your GitHub account, follow these steps:

### 1. Generate a new SSH key

`ssh-keygen -t rsa -b 4096 -C "your_email@example.com"`

- When prompted for a file path, enter a custom name (e.g., ~/.ssh/id_rsa)
- Press Enter for passphrase (or add one for more security)

### 2. Add the key to the SSH agent

```
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```

### 3. Copy the public key to your clipboard

`cat ~/.ssh/id_rsa.pub`

### 4. Add the key to your GitHub account

- Go to GitHub → Settings → SSH and GPG Keys
- Click New SSH key
- Paste the copied key
- Give it a recognizable title (e.g., Work Laptop Key)


## ✅ Prerequisites

Ensure the following tools and configurations are in place:

### 1. SSH Key: 
 - Your SSH key is already added to your GitHub account.
 - The path to the key is correct in the script.
 - Run `ssh-add ~/.ssh/id_rsa` manually if needed.

### 2. GitHub CLI (gh)
 - Install from GitHub CLI documentation
 - Authenticate using: `gh auth login`

### 3. Git installed

## 🚀 How to Run

Make the script executable:

`chmod +x migrate_to_github.sh`

Run the script:

`./migrate_to_github.sh`

## 🔄 What It Does

For each repository in the list:

1. Navigates into the repo directory.
2. Adds the SSH key to your agent.
3. Checks if the repository exists on GitHub.
    - If not, it creates it and pushes code.
    - If yes, it adds the remote and pushes code.
4. Pushes all branches and all tags to GitHub.

## 🧪 Example Output

```
Processing repository: project_one
Adding SSH key to ssh-agent...
Repository project_one already exists on GitHub. Adding remote...
Pushing all branches for project_one to GitHub...
Pushing all tags for project_one to GitHub...
Successfully processed project_one.
```

## 📌 Notes

- If the remote already exists, `git remote add` will silently fail (which is fine).
- You can change visibility from `--private` to `--public` in the gh repo create command if needed.

## 🧹 Cleanup Tip

If your SSH key is not persisting, you may need to run:

```
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```

## 📤 Author

**Thirumalai Raja**

GitHub: [thirumalai-py](https://github.com/thirumalai-py)





#!/bin/bash

# Define base directories and SSH alias
BASE_DIR="/your/local/path"         # Replace with the actual path where your repositories are located
GITHUB_HOST="github.com"            # Replace SSH alias for your GitHub account if needed
GITHUB_ORG="github-username"        # Your GitHub profile or username
SSH_KEY="~/.ssh/id_rsa"             # Path to the Github SSH key

# Array of repository names
REPOS=(
    "project_one"
    "project_two"
    "project_three"
    "project_four"
)

# Iterate through each repository
for REPO in "${REPOS[@]}"; do
    echo "Processing repository: $REPO"
    REPO_DIR="$BASE_DIR/$REPO"
    
    # Check if directory exists
    if [ -d "$REPO_DIR" ]; then
        cd "$REPO_DIR" || { echo "Failed to access directory $REPO_DIR"; continue; }

        # Add the company SSH key to the ssh-agent
        echo "Adding SSH key to ssh-agent..."
        ssh-add $SSH_KEY || { echo "Failed to add SSH key. Exiting."; exit 1; }

        # Check if the repository already exists on GitHub
        REPO_EXISTS=$(gh repo view "$GITHUB_ORG/$REPO" --json name --jq .name 2>/dev/null)

        if [ -z "$REPO_EXISTS" ]; then
            echo "Repository $REPO does not exist on GitHub. Creating..."
            gh repo create "$GITHUB_ORG/$REPO" --private --source=. --remote=github --push || { echo "Failed to create $REPO on GitHub"; continue; }
        else
            echo "Repository $REPO already exists on GitHub. Adding remote..."
            git remote add github "git@$GITHUB_HOST:$GITHUB_ORG/$REPO.git" 2>/dev/null
        fi

        # Push all branches and tags to GitHub
        echo "Pushing all branches for $REPO to GitHub..."
        git push github --all || { echo "Failed to push branches for $REPO"; continue; }

        echo "Pushing all tags for $REPO to GitHub..."
        git push github --tags || { echo "Failed to push tags for $REPO"; continue; }

        echo "Successfully processed $REPO."
    else
        echo "Directory $REPO_DIR does not exist. Skipping..."
    fi
done

echo "Migration complete."

#!/bin/bash

# Function to update the version in the setup.py file
update_version() {
    local version_file=$1
    local do_push=$2
    local current_version
    local new_version

    # Extract the current version from the setup.py file
    current_version=$(grep -Eo '__version__\s*=\s*"[0-9]+\.[0-9]+\.[0-9]+"' $version_file | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')

    if [ -z "$current_version" ]; then
        echo "Version not found in $version_file"
        exit 1
    fi

    IFS='.' read -r -a version_parts <<< "$current_version"
    major=${version_parts[0]}
    minor=${version_parts[1]}
    patch=${version_parts[2]}

    if [ "$do_push" = true ]; then
        # Increment the minor version and reset the patch version
        new_version="$major.$((minor + 1)).0"
    else
        # Update the patch version with the current timestamp
        new_patch=$(date +%s)
        new_version="$major.$minor.$new_patch"
    fi

    # Replace the version in the file
    sed -i "s/__version__\s*=\s*\"$current_version\"/__version__ = \"$new_version\"/" $version_file

    echo "Updated version to $new_version"
}

# Main script logic
VERSION_FILE="setup.py"
DO_PUSH=false
COMMIT_MESSAGE=""

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --push) DO_PUSH=true ;;
        --message) COMMIT_MESSAGE="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Check if commit message is provided
if [ -z "$COMMIT_MESSAGE" ]; then
    echo "Commit message is required. Use --message to provide a commit message."
    exit 1
fi

# Update the version in the setup.py file
update_version "$VERSION_FILE" "$DO_PUSH"

# Add changes to git
git add .

# Commit changes
git commit -m "$COMMIT_MESSAGE: Update version to $(grep -Eo '__version__\s*=\s*"[0-9]+\.[0-9]+\.[0-9]+"' $VERSION_FILE | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')"

if [ "$DO_PUSH" = true ]; then
    # Push changes to the repository
    git push
fi

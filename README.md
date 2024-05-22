# Version Control Automation Script

This repository contains a script that automates the versioning of a Python package before each Git commit. The version is updated in the `setup.py` file based on the current timestamp for patch updates or minor version increments for Git pushes. The script also supports custom commit messages.

## Prerequisites

- Git
- Bash
- Python

## Setup

1. Clone the repository:

    ```sh
    git clone https://github.com/satyamsc0/change-version-test.git
    cd change-version-test
    ```

2. Ensure the `change_version.sh` script is executable:

    ```sh
    chmod +x change_version.sh
    ```

## Script Usage

The script provides two main functionalities:
1. **Update the version and commit changes**.
2. **Update the version, commit changes, and push to the remote repository**.

### Parameters

- `--message`: Commit message (required).
- `--push`: Optional flag to push changes to the remote repository.

### Examples

#### 1. Update the version and commit changes

To update the version and commit changes with a custom message:

```sh
./change_version.sh --message "Your commit message"

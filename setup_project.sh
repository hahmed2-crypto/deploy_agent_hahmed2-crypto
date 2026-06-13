#!/bin/bash

echo "========================================="
echo "   Automated Project Bootstrapping Agent "
echo "========================================="

# 1. Prompt the user for the project suffix
read -p "Enter project unique identifier/input: " USER_INPUT

# Sanitize input: ensure it is not empty
if [ -z "$USER_INPUT" ]; then
    echo "[Error] Project identifier cannot be empty!"
    exit 1
fi

PROJECT_DIR="attendance_tracker_${USER_INPUT}"

# 2. Robust error handling if directory already exists
if [ -d "$PROJECT_DIR" ]; then
    echo "[Error] The directory '$PROJECT_DIR' already exists."
    read -p "Would you like to overwrite it? (y/N): " OVERWRITE_CHOICE
    if [[ "$OVERWRITE_CHOICE" =~ ^[Yy]$ ]]; then
        echo "[*] Removing existing directory..."
        rm -rf "$PROJECT_DIR"
    else
        echo "[*] Aborting execution to prevent overwriting data."
        exit 1
    fi
fi

echo "[*] Generating workspace directory structure..."
# Create the parent and nested directories seamlessly
mkdir -p "$PROJECT_DIR/Helpers"
mkdir -p "$PROJECT_DIR/reports"

# 3. Simulate deploying code assets (creates template files)
echo "[*] Deploying system code templates and assets..."
touch "$PROJECT_DIR/attendance_checker.py"
touch "$PROJECT_DIR/image.png"
touch "$PROJECT_DIR/reports/reports.log"

# Create a base config.json layout for step 3
cat <<EOF > "$PROJECT_DIR/Helpers/config.json"
{
  "warning_threshold": 75,
  "failure_threshold": 50
}
EOF

# Create a base assets.csv
echo "student_id,name,status" > "$PROJECT_DIR/Helpers/assets.csv"

echo "[Success] Phase 1 Directory Structure Ready."


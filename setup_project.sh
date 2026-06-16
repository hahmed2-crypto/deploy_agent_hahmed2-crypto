#!/bin/bash

# ==============================================================================
# PHASE 3: PROCESS MANAGEMENT (THE SIGNAL TRAP)
# This must be declared at the top so it is active immediately.
# ==============================================================================
cleanup_on_interrupt() {
    echo -e "\n\n[!] SIGINT (Ctrl+C) detected! Initiating emergency cleanup..."
    
    # If the project directory has been set and exists, archive it and delete it
    if [ -n "$PROJECT_DIR" ] && [ -d "$PROJECT_DIR" ]; then
        ARCHIVE_NAME="${PROJECT_DIR}_archive.tar.gz"
        echo "[*] Bundling partial project state into: $ARCHIVE_NAME"
        tar -czf "$ARCHIVE_NAME" "$PROJECT_DIR" 2>/dev/null
        
        echo "[*] Deleting incomplete directory to keep workspace clean: $PROJECT_DIR"
        rm -rf "$PROJECT_DIR"
    fi
    
    echo "[X] Cleanup complete. Exiting safely."
    exit 1
}

# Register the trap for SIGINT (Ctrl+C)
trap cleanup_on_interrupt SIGINT

# ==============================================================================
# PHASE 1: DIRECTORY ARCHITECTURE & AUTOMATION
# ==============================================================================
echo "========================================="
echo "   Automated Project Bootstrapping Agent "
echo "========================================="

read -p "Enter project unique identifier/input: " USER_INPUT

if [ -z "$USER_INPUT" ]; then
    echo "[Error] Project identifier cannot be empty!"
    exit 1
fi

PROJECT_DIR="attendance_tracker_${USER_INPUT}"

# Check if directory already exists
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

# Verify downloaded source files exist in the root folder before copying
if [ ! -f "attendance_checker.py" ] || [ ! -f "assets.csv" ] || [ ! -f "config.json" ] || [ ! -f "reports.log" ]; then
    echo "[Error] Missing required source files in the root execution directory!"
    exit 1
fi

echo "[*] Generating workspace directory structure..."
mkdir -p "$PROJECT_DIR/Helpers"
mkdir -p "$PROJECT_DIR/reports"

echo "[*] Deploying system code and assets..."
cp "attendance_checker.py" "$PROJECT_DIR/"
cp "assets.csv" "$PROJECT_DIR/Helpers/"
cp "config.json" "$PROJECT_DIR/Helpers/"
cp "reports.log" "$PROJECT_DIR/reports/"
touch "$PROJECT_DIR/image.png"

# ==============================================================================
# PHASE 2: DYNAMIC CONFIGURATION (STREAM EDITING)
# ==============================================================================
echo "-----------------------------------------"
echo "         Configuration Settings          "
echo "-----------------------------------------"

read -p "Enter Warning Threshold percentage (Default: 75): " WARNING_VAL
if [ -z "$WARNING_VAL" ]; then
    WARNING_VAL=75
fi

if [[ ! "$WARNING_VAL" =~ ^[0-9]+$ ]]; then
    echo "[Error] Warning threshold must be a number! Clean exiting."
    rm -rf "$PROJECT_DIR"
    exit 1
fi

read -p "Enter Failure Threshold percentage (Default: 50): " FAILURE_VAL
if [ -z "$FAILURE_VAL" ]; then
    FAILURE_VAL=50
fi

if [[ ! "$FAILURE_VAL" =~ ^[0-9]+$ ]]; then
    echo "[Error] Failure threshold must be a number! Clean exiting."
    rm -rf "$PROJECT_DIR"
    exit 1
fi

# Edit config.json in place
sed -i "s/\"warning\": [0-9]*/\"warning\": $WARNING_VAL/" "$PROJECT_DIR/Helpers/config.json"
sed -i "s/\"failure\": [0-9]*/\"failure\": $FAILURE_VAL/" "$PROJECT_DIR/Helpers/config.json"

echo "[*] Successfully updated config.json with custom parameters."


# ==============================================================================
# PHASE 4: ENVIRONMENT VALIDATION (HEALTH CHECK)
# ==============================================================================
echo "-----------------------------------------"
echo "         System Validation Checker             "
echo "-----------------------------------------"

echo "[*] Validating local dependencies..."
python3 --version > /dev/null 2>&1

if [ $? -eq 0 ]; then
    PYTHON_VER=$(python3 --version)
    echo "[Success] Environment verified: $PYTHON_VER is installed."
else
    echo "[Warning] Dependency Missing: python3 could not be found on this system."
fi

echo "========================================="
echo " Setup Finished Successfully for $PROJECT_DIR"
echo "========================================="




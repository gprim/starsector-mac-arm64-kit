#!/bin/bash
set -e

# Default to the standard Applications folder if no path is provided
APP_PATH="${1:-/Applications/Starsector.app}"
ZIP_FILE="Starsector_Mac_ARM64_Java25.zip"

if [ ! -d "$APP_PATH" ]; then
    echo "Error: Could not find Starsector at $APP_PATH"
    echo "Usage: ./install.sh [path_to_Starsector.app]"
    exit 1
fi

if [ ! -f "$ZIP_FILE" ]; then
    echo "Error: Could not find $ZIP_FILE in the current directory."
    echo "Make sure you run ./build.sh first!"
    exit 1
fi

echo "==> Extracting $ZIP_FILE into $APP_PATH..."
# Unzip overwriting existing files (-o) and quietly (-q)
unzip -o -q "$ZIP_FILE" -d "$APP_PATH"

echo "==> Enabling allowAnyJavaVersion in settings.json..."
# Find the settings.json file within the app (it usually lives in Contents/Resources/Java/data/config/settings.json on Mac)
SETTINGS_FILE=$(find "$APP_PATH" -name "settings.json" | grep "Java/data/config" | head -n 1)

if [ -n "$SETTINGS_FILE" ] && [ -f "$SETTINGS_FILE" ]; then
    echo "Found settings.json at $SETTINGS_FILE"
    # Use sed to replace false with true for the java version check
    sed -i '' 's/"allowAnyJavaVersion":false/"allowAnyJavaVersion":true/g' "$SETTINGS_FILE"
    sed -i '' 's/"allowAnyJavaVersion": false/"allowAnyJavaVersion": true/g' "$SETTINGS_FILE"
    echo "==> Successfully patched allowAnyJavaVersion to true!"
else
    echo "Warning: Could not find settings.json in $APP_PATH to patch."
    echo "You may need to change allowAnyJavaVersion to true manually."
fi

echo "=========================================================="
echo "Installation complete!"
echo "Starsector is now configured with the Java 25 ARM64 kit."
echo "=========================================================="

#!/bin/bash
set -e

# Default path unless provided
APP_PATH="${1:-/Applications/Starsector.app}"

if [ "$EUID" -ne 0 ]; then
    echo "Error: Modifying apps in the /Applications folder requires administrator privileges on modern macOS."
    echo "Please run this script using sudo:"
    echo "    sudo bash install.sh"
    exit 1
fi

if [ ! -d "$APP_PATH" ]; then
    echo "Error: Could not find Starsector at $APP_PATH"
    echo "Usage: ./install.sh [/path/to/Starsector.app]"
    exit 1
fi

if [ ! -d "Contents" ]; then
    echo "Error: Could not find the 'Contents' folder in the current directory."
    echo "Please run this script from inside the unzipped payload folder."
    exit 1
fi

echo "==> Installing payload into $APP_PATH..."
cp -Rf Contents/* "$APP_PATH/Contents/"

echo "==> Enabling allowAnyJavaVersion in settings.json..."
# Find the settings.json file within the app (it usually lives in Contents/Resources/Java/data/config/settings.json on Mac)
SETTINGS_FILE=$(find "$APP_PATH" -name "settings.json" | grep "Java/data/config" | head -n 1)

if [ -n "$SETTINGS_FILE" ] && [ -f "$SETTINGS_FILE" ]; then
    echo "Found settings.json at $SETTINGS_FILE"
    sed -i '' 's/"allowAnyJavaVersion":false/"allowAnyJavaVersion":true/g' "$SETTINGS_FILE"
    
    # Fix OpenAL sound deadlock on Apple Silicon
    if ! grep -q "loadSoundsConcurrently" "$SETTINGS_FILE"; then
        sed -i '' 's/^{/{\n\t"loadSoundsConcurrently":false,/g' "$SETTINGS_FILE"
    fi
    
    echo "==> Successfully patched settings.json!"
else
    echo "Warning: Could not find settings.json in $APP_PATH to patch."
    echo "You may need to change allowAnyJavaVersion to true manually."
fi

echo "==> Removing macOS quarantine attributes..."
xattr -rd com.apple.quarantine "$APP_PATH" 2>/dev/null || true

echo "=========================================================="
echo "Installation complete!"
echo "Starsector is now configured with the Java 25 ARM64 kit."
echo "=========================================================="

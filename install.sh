#!/bin/bash
set -e

# Default path unless provided
APP_PATH="${1:-/Applications/Starsector.app}"
ZIP_FILE="Starsector_Mac_ARM64_Java25.zip"

if [ ! -d "$APP_PATH" ]; then
    echo "Error: Could not find Starsector at $APP_PATH"
    echo "Usage: ./install.sh [/path/to/Starsector.app]"
    exit 1
fi

if [ ! -f "$ZIP_FILE" ]; then
    echo "Error: Could not find $ZIP_FILE in current directory."
    echo "Please run this script from the folder containing the zip."
    exit 1
fi

echo "==> Extracting $ZIP_FILE into $APP_PATH..."
unzip -o -q "$ZIP_FILE" -d "$APP_PATH"

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

# Fix Mac classpath issue on Java 17+ (appends :. to the -cp string in starsector_mac.sh)
MAC_LAUNCHER="$APP_PATH/Contents/MacOS/starsector_mac.sh"
if [ -f "$MAC_LAUNCHER" ]; then
    echo "==> Patching classpath in starsector_mac.sh to fix Java 25 resource loading..."
    # Only patch if not already patched
    if ! grep -q "\:\. \\\\" "$MAC_LAUNCHER"; then
        sed -i '' 's/webp-imageio-0.1.6.jar \\/webp-imageio-0.1.6.jar:. \\/g' "$MAC_LAUNCHER"
    fi
fi

echo "=========================================================="
echo "Installation complete!"
echo "Starsector is now configured with the Java 25 ARM64 kit."
echo "=========================================================="

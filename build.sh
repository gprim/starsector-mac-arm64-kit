#!/bin/bash
set -e

# Default zip name unless provided
INPUT_ZIP="${1:-Mikohime_Mac_Kit.zip}"
OUTPUT_ZIP="Starsector_Mac_ARM64_Java25.zip"

if [ ! -f "$INPUT_ZIP" ]; then
    echo "Error: Could not find base community kit zip: $INPUT_ZIP"
    echo "Usage: ./build.sh [path_to_mikohime_mac_kit.zip]"
    exit 1
fi

echo "==> Setting up build directory..."
rm -rf build
mkdir -p build
unzip -q "$INPUT_ZIP" -d build/

echo "==> Removing old JRE from community kit..."
rm -rf build/jre
rm -rf build/starsector-core/jre 2>/dev/null || true

echo "==> Downloading Java 25 (LTS) JRE for macOS ARM64 (aarch64)..."
JAVA_URL="https://api.adoptium.net/v3/binary/latest/25/ga/mac/aarch64/jre/hotspot/normal/eclipse?project=jdk"
curl -L -o java25_mac_aarch64.tar.gz "$JAVA_URL"

echo "==> Extracting Java 25..."
mkdir -p build/jre
tar -xzf java25_mac_aarch64.tar.gz -C build/jre --strip-components=3

echo "==> Patching vmparams to remove deprecated JVM flags..."
# Find vmparams file (could be in root or starsector-core)
VMPARAMS_FILE=$(find build -name "vmparams" | head -n 1)

if [ -n "$VMPARAMS_FILE" ] && [ -f "$VMPARAMS_FILE" ]; then
    echo "Found vmparams at $VMPARAMS_FILE. Cleaning up legacy flags..."
    # Java 25 does not support CMS, BiasedLocking, etc.
    sed -i '' 's/-XX:+UseConcMarkSweepGC//g' "$VMPARAMS_FILE"
    sed -i '' 's/-XX:+CMSClassUnloadingEnabled//g' "$VMPARAMS_FILE"
    sed -i '' 's/-XX:+UseParNewGC//g' "$VMPARAMS_FILE"
    sed -i '' 's/-XX:+UseBiasedLocking//g' "$VMPARAMS_FILE"
    sed -i '' 's/-Xmn[0-9]*[mMgG]//g' "$VMPARAMS_FILE"
    echo "Cleaned up vmparams."
else
    echo "No vmparams file found in the kit. (This is fine if it relies on the game's default vmparams)."
fi

echo "==> Packaging $OUTPUT_ZIP..."
cd build
zip -q -r "../$OUTPUT_ZIP" ./*
cd ..

echo "==> Cleaning up..."
rm -rf build java25_mac_aarch64.tar.gz

echo "=========================================================="
echo "Done! Created $OUTPUT_ZIP"
echo "Distribute this file to users. They just need to extract it"
echo "into their Starsector folder and set allowAnyJavaVersion"
echo "to true in starsector-core/data/config/settings.json."
echo "=========================================================="

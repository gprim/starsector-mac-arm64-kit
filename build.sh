#!/bin/bash
set -e

OUTPUT_ZIP="Starsector_Mac_ARM64_Java25.zip"

echo "==> Setting up build directory..."
rm -rf build
mkdir -p build/Contents/Home
mkdir -p build/Contents/MacOS
mkdir -p build/Contents/Resources/Java

echo "==> Downloading Java 25 (LTS) JRE for macOS ARM64 (aarch64)..."
JAVA_URL="https://api.adoptium.net/v3/binary/latest/25/ga/mac/aarch64/jre/hotspot/normal/eclipse?project=jdk"
curl -sL -o java25_mac_aarch64.tar.gz "$JAVA_URL"

echo "==> Extracting Java 25 into Contents/Home..."
# The tar.gz contains a folder like jdk-25.x.x+x-jre/Contents/Home/...
# We strip the first 3 components (jdk.../Contents/Home) and put it directly in build/Contents/Home
tar -xzf java25_mac_aarch64.tar.gz -C build/Contents/Home --strip-components=3

echo "==> Copying Mac ARM64 native LWJGL libraries..."
if [ ! -d "mac-native-libs" ]; then
    echo "Error: mac-native-libs directory not found!"
    exit 1
fi

cp -R mac-native-libs/MacOS/* build/Contents/MacOS/
cp -R mac-native-libs/Resources/Java/* build/Contents/Resources/Java/

echo "==> Packaging $OUTPUT_ZIP..."
cd build
zip -q -r "../$OUTPUT_ZIP" ./*
cd ..

echo "==> Cleaning up..."
rm -rf build java25_mac_aarch64.tar.gz

echo "=========================================================="
echo "Done! Created $OUTPUT_ZIP"
echo "Distribute this zip along with install.sh to users."
echo "=========================================================="

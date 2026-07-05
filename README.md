# Starsector Mac ARM64 Native Kit Builder (Java 25 LTS)

This repository contains an automated build script designed to upgrade existing community Mac ARM64 Conversion Kits for Starsector to use **Java 25 (LTS)** instead of older Java versions like Java 17 or 23.

By using Java 25 LTS, you get the absolute latest stable performance enhancements from the JVM natively running on Apple Silicon (M1/M2/M3 chips) without the overhead of Rosetta 2.

## How It Works

Because the custom ARM64 graphics library (`lwjgl3ify`) used in the community kits is distributed as compiled binaries (and the source isn't public), this script acts as a patcher. It takes an existing Mac community kit, strips out the old Java runtime, automatically downloads and injects the latest Azul Zulu Java 25 JRE, sanitizes the launch parameters to prevent crashes, and repacks it.

## How to Build the Kit (For Developers)

1. Obtain a base community Mac ARM64 kit `.zip` file (e.g. Mikohime's Mac Kit from the Starsector Forums/Discord).
2. Place the `.zip` file into this repository folder.
3. Run the build script in your terminal, providing the name of the zip file:
   ```bash
   ./build.sh Mikohime_Mac_Kit.zip
   ```
4. The script will output a new file named `Starsector_Mac_ARM64_Java25.zip`.

## How to Install the Kit (For End Users)

Once you have the `Starsector_Mac_ARM64_Java25.zip` file:

1. Locate your Starsector installation on your Mac (e.g., `Starsector.app`).
2. Right click it and select **"Show Package Contents"**.
3. Extract the contents of `Starsector_Mac_ARM64_Java25.zip` directly into the game folder, merging/overwriting files as prompted.
4. Open `starsector-core/data/config/settings.json` in a text editor.
5. Search for `allowAnyJavaVersion` and change it from `false` to `true`.
6. Launch the game! It will now run natively on ARM64 using Java 25.

### Troubleshooting
If the game icon bounces and then immediately closes, check the `vmparams` file (or `Info.plist`) for any old JVM arguments. Specifically, if you see things like `-XX:+UseBiasedLocking` or `-XX:+UseConcMarkSweepGC`, remove them, as Java 25 no longer supports these older garbage collection methods.

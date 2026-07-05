#!/bin/bash

DIR="$( cd "$( dirname "$BASH_SOURCE[0]}" )" && pwd )"

cd "$DIR"
cd "../Resources/Java"

export JAVA_HOME=../../Home
"$JAVA_HOME/bin/java" \
    -Xdock:name="Starsector" \
    -Xdock:icon=../../Resources/s_icon128.icns \
    -Dapple.laf.useScreenMenuBar=false \
    -Dcom.apple.macos.useScreenMenuBar=false \
    -Dapple.awt.showGrowBox=false \
    -Dfile.encoding=UTF-8 \
    -Dorg.lwjgl.openal.libname="$DIR/../Resources/Java/native/macosx/libopenal.dylib" \
    -XX:+UseShenandoahGC \
    -XX:+AlwaysPreTouch \
    -XX:+ParallelRefProcEnabled \
    -Djava.library.path=../../Resources/Java/native/macosx \
    -Djava.util.Arrays.useLegacyMergeSort=true \
    -noverify \
    -XX:+UnlockDiagnosticVMOptions \
    -XX:-BytecodeVerificationLocal \
    -XX:-BytecodeVerificationRemote \
    --add-opens=java.base/sun.nio.ch=ALL-UNNAMED \
    --add-opens=java.base/java.nio=ALL-UNNAMED \
    --add-opens=java.base/java.nio.Buffer.UNSAFE=ALL-UNNAMED \
    --add-opens=java.base/java.util=ALL-UNNAMED \
    --add-opens=java.base/java.util.concurrent=ALL-UNNAMED \
    --add-opens=java.base/java.util.concurrent.locks=ALL-UNNAMED \
    --add-opens=java.base/jdk.internal.ref=ALL-UNNAMED \
    --add-opens=java.base/java.lang.reflect=ALL-UNNAMED \
    --add-opens=java.base/java.lang.ref=ALL-UNNAMED \
    --add-opens=java.base/java.text=ALL-UNNAMED \
    --add-opens=java.desktop/java.awt.font=ALL-UNNAMED \
    --add-opens=java.desktop/java.awt.Rectangle=ALL-UNNAMED \
    --add-opens=java.desktop/java.awt=ALL-UNNAMED \
    --add-opens=java.desktop/sun.lwawt.macosx=ALL-UNNAMED \
    --add-opens=java.desktop/sun.lwawt=ALL-UNNAMED \
    --add-opens=java.desktop/sun.awt=ALL-UNNAMED \
    --add-exports=java.base/jdk.internal.ref=ALL-UNNAMED \
    --add-exports=java.base/jdk.internal.misc=ALL-UNNAMED \
    --add-exports=java.base/sun.nio.ch=ALL-UNNAMED \
    -Xms8192m \
    -Xmx8192m \
    -Xss4m \
    -Dcom.fs.starfarer.settings.paths.saves=../../../saves \
    -Dcom.fs.starfarer.settings.paths.screenshots=../../../screenshots \
    -Dcom.fs.starfarer.settings.paths.mods=../../../mods \
    -Dcom.fs.starfarer.settings.paths.logs=../../../logs \
    -Dcom.fs.starfarer.settings.osx=true \
    -cp ../../Resources/Java/AppleJavaExtensions.jar:../../Resources/Java/commons-compiler-jdk.jar:../../Resources/Java/commons-compiler.jar:../../Resources/Java/fs.sound_obf.jar:../../Resources/Java/janino.jar:../../Resources/Java/jinput.jar:../../Resources/Java/jogg-0.0.7.jar:../../Resources/Java/jorbis-0.0.15.jar:../../Resources/Java/json.jar:../../Resources/Java/log4j-1.2.9.jar:../../Resources/Java/lwjgl.jar:../../Resources/Java/lwjgl_util.jar:../../Resources/Java/starfarer.api.jar:../../Resources/Java/starfarer_obf.jar:../../Resources/Java/fs.common_obf.jar:../../Resources/Java/xstream-1.4.10.jar:../../Resources/Java/txw2-3.0.2.jar:../../Resources/Java/jaxb-api-2.4.0-b180830.0359.jar:../../Resources/Java/webp-imageio-0.1.6.jar:. \
    com.fs.starfarer.StarfarerLauncher \
    "$@"

exit 0

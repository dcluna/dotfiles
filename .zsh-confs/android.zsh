export JAVA_HOME=$HOME/bin/jdk1.7.0_75
export ANDROID_HOME=$HOME/Android/Sdk
export NDK_HOME=$HOME/bin/android-ndk-r10d
export NDKROOT=$NDK_HOME

export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

# my current gradle home
export PATH="$HOME/bin/gradle-2.5/bin:$PATH"

# creating a gradle daemon on build for speed
export GRADLE_OPTS="-Dorg.gradle.daemon=true"
export GROOVY_HOME="/usr"

alias generatebuildxmlandroid='$ANDROID_HOME/tools/android update project -p `pwd`'

# avoiding the need for -force-32bit when calling stock Android emulators
export ANDROID_EMULATOR_FORCE_32BIT=true

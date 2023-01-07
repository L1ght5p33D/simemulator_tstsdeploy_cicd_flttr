FROM ubuntu:16.04

ENV ANDROID_HOME="/opt/android-sdk" \
#    ANDROID_NDK="/opt/android-ndk" \
FLUTTER_HOME="/opt/flutter" \
JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

# Get the latest version from https://developer.android.com/studio/index.html
#
ENV ANDROID_SDK_TOOLS_VERSION="4333796"

# Get the latest version from https://developer.android.com/ndk/downloads/index.html
#ENV ANDROID_NDK_VERSION="19"

RUN locale -a

# Set locale
ENV LANG="en_US.UTF-8" \
LANGUAGE="en_US.UTF-8" \
LC_ALL="en_US.UTF-8"

RUN apt-get clean && apt-get update -qq && apt-get install -qq -y apt-utils locales && locale-gen en_US en_US.UTF-8

RUN update-locale

ENV DEBIAN_FRONTEND="noninteractive"

ENV ANDROID_SDK_HOME="$ANDROID_HOME"
#ENV ANDROID_NDK_HOME="$ANDROID_NDK/android-ndk-r$ANDROID_NDK_VERSION"

ENV PATH="$PATH:$ANDROID_SDK_HOME/emulator:$ANDROID_SDK_HOME/tools/bin:$ANDROID_SDK_HOME/tools:$ANDROID_SDK_HOME/platform-tools:$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin"

# Installing packages
RUN apt-get update -qq > /dev/null && \
apt-get install -qq locales > /dev/null && \
apt-get install -qq --no-install-recommends \
sudo \
build-essential \
autoconf \
curl \
git \
lib32stdc++6 \
lib32z1 \
lib32z1-dev \
lib32ncurses5 \
libc6-dev \
libgmp-dev \
libglu1-mesa \
libmpc-dev \
libmpfr-dev \
libxslt-dev \
libxml2-dev \
m4 \
ncurses-dev \
#       ocaml \
openjdk-8-jdk \
openssh-client \
pkg-config \
python-software-properties \
ruby-full \
software-properties-common \
unzip \
wget \
vim \
zip \
zlib1g-dev > /dev/null && \
rm -rf /tmp/* /var/tmp/* && \
echo "Installing fastlane" && \
gem install fastlane --quiet --no-document > /dev/null


# Install Flutter sdk
RUN echo 'installing Flutter' && \
cd /opt
ADD flutter_linux_v1.2.1-stable.tar.xz /opt
#RUN wget "https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.2.1-stable.tar.xz"
RUN cd /opt && \
ls -al && \
#   echo 'pre tar' && \
# tar xf ./flutter_linux_v1.2.1-stable.tar.xz && \
echo 'unpackage flutter tar complete' && \
echo 'done'
# rm -f ./flutter_linux_v1.2.1-stable.tar.xz
RUN cd /opt/flutter/bin && \
yes | ./flutter doctor --android-licenses && \
./flutter doctor -v



# Install Android SDK
RUN echo "Installing sdk tools ${ANDROID_SDK_TOOLS_VERSION}"
RUN  cd /opt && \
wget --output-document=sdk-tools.zip "https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS_VERSION}.zip" && \
mkdir --parents "$ANDROID_HOME" && \

unzip -q sdk-tools.zip -d "$ANDROID_HOME" && \

rm --force sdk-tools.zip && \
echo "Done"
#echo "Installing ndk r${ANDROID_NDK_VERSION}" && \
#    wget --quiet --output-document=android-ndk.zip \
#    "http://dl.google.com/android/repository/android-ndk-r${ANDROID_NDK_VERSION}-linux-x86_64.zip" && \
#    mkdir --parents "$ANDROID_NDK_HOME" && \
#    unzip -q android-ndk.zip -d "$ANDROID_NDK" && \
#    rm --force android-ndk.zip

# Install SDKs
# Please keep these in descending order!
# The `yes` is for accepting all non-standard tool licenses.
RUN mkdir --parents "$ANDROID_HOME/.android/" && \
echo '### User Sources for Android SDK Manager' > \
"$ANDROID_HOME/.android/repositories.cfg" && \
yes | "$ANDROID_HOME"/tools/bin/sdkmanager --licenses > /dev/null && \
echo "Installing platforms" && \
yes | "$ANDROID_HOME"/tools/bin/sdkmanager \
"platforms;android-28" \
"platforms;android-27" > /dev/null && \
echo "Installing platform tools " && \
yes | "$ANDROID_HOME"/tools/bin/sdkmanager \
"platform-tools" > /dev/null && \
echo "Installing build tools " && \
yes | "$ANDROID_HOME"/tools/bin/sdkmanager \
"build-tools;28.0.3" "build-tools;28.0.2" \
"build-tools;27.0.3" "build-tools;27.0.2" "build-tools;27.0.1" > /dev/null &&  \
#        "build-tools;26.0.2" "build-tools;26.0.1" "build-tools;26.0.0" > /dev/null && \
#       "build-tools;25.0.3" "build-tools;25.0.2" \
#        "build-tools;25.0.1" "build-tools;25.0.0" \
#        "build-tools;24.0.3" "build-tools;24.0.2" \
#        "build-tools;24.0.1" "build-tools;24.0.0" > /dev/null && \
# echo "Installing build tools " && \
#    yes | "$ANDROID_HOME"/tools/bin/sdkmanager \
#        "build-tools;23.0.3" "build-tools;23.0.2" "build-tools;23.0.1" \
#        "build-tools;22.0.1" \
#        "build-tools;21.1.2" \
#        "build-tools;20.0.0" \
#        "build-tools;19.1.0" \
#        "build-tools;18.1.1" \
#        "build-tools;17.0.0" > /dev/null && \
echo "Installing extras " && \
yes | "$ANDROID_HOME"/tools/bin/sdkmanager \
"extras;android;m2repository" \
"extras;google;m2repository" > /dev/null && \
echo "Installing play services " && \
yes | "$ANDROID_HOME"/tools/bin/sdkmanager \
"extras;google;google_play_services" \
"extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" \
"extras;m2repository;com;android;support;constraint;constraint-layout;1.0.1" > /dev/null && \
echo "Installing Google APIs" && \
yes | "$ANDROID_HOME"/tools/bin/sdkmanager \
"add-ons;addon-google_apis-google-24" \
"add-ons;addon-google_apis-google-23" \
"add-ons;addon-google_apis-google-22" \
"add-ons;addon-google_apis-google-21" \
"add-ons;addon-google_apis-google-19" \
"add-ons;addon-google_apis-google-18" \
"add-ons;addon-google_apis-google-17" \
"add-ons;addon-google_apis-google-16" > /dev/null && \
echo "Installing emulator " && \
yes | "$ANDROID_HOME"/tools/bin/sdkmanager "emulator" > /dev/null && \
echo "Installing kotlin" && \
wget --quiet -O sdk.install.sh "https://get.sdkman.io" && \
bash -c "bash ./sdk.install.sh > /dev/null && source ~/.sdkman/bin/sdkman-init.sh && sdk install kotlin" && \
rm -f sdk.install.sh


RUN chmod 777 $ANDROID_HOME/.android


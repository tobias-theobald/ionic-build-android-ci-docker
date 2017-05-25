FROM ubuntu:16.04
MAINTAINER Niklas Merz

# Install apt packages
RUN apt-get update && apt-get install --yes curl
RUN curl --silent --location https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y git lib32stdc++6 lib32z1 nodejs s3cmd build-essential openjdk-8-jdk-headless sendemail libio-socket-ssl-perl libnet-ssleay-perl wget unzip && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install android SDK, tools and platforms
RUN cd /opt && curl https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz -o android-sdk.tgz && tar xzf android-sdk.tgz && rm android-sdk.tgz
ENV ANDROID_HOME /opt/android-sdk-linux
RUN echo 'y' | /opt/android-sdk-linux/tools/android update sdk -u -a -t platform-tools,build-tools-25.0.3,,android-25,extra-google-m2repository,extra-android-m2repository

# Install npm packages
RUN npm i -g cordova ionic gulp bower grunt phonegap && npm cache clean

RUN wget https://services.gradle.org/distributions/gradle-3.4.1-bin.zip
RUN mkdir /opt/gradle && unzip -d /opt/gradle gradle-3.4.1-bin.zip
ENV PATH=$PATH:/opt/gradle/gradle-3.4.1/bin


# Create dummy app to build and preload gradle and maven dependencies
COPY app /app
RUN cd /app && ionic cordova platform add android && ionic cordova build android && rm -rf * .??*

WORKDIR /app

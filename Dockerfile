# ARGUMENTS
ARG DISTR=20.04
ARG SDK_MANAGER_DOCKER_VERSION=1.9.3.10904

# set defalt base_image
FROM sdkmanager:${SDK_MANAGER_DOCKER_VERSION}-Ubuntu_${DISTR}
#FROM sdkmanager:1.9.3.10904-Ubuntu_18.04

# add new sudo user
ENV USERNAME nvidia

# Install required packages
USER root
RUN echo "Acquire::GzipIndexes \"false\"; Acquire::CompressionTypes::Order:: \"gz\";" > /etc/apt/apt.conf.d/docker-gzip-indexes \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        apt-utils \
        curl \
        git \
        vim \
        gpg \
        gpg-agent \
        gpgconf \
        gpgv \
        less \
        libcanberra-gtk-module \
        libcanberra-gtk3-module \
        libgconf-2-4 \
        libgtk-3-0 \
        libnss3 \
        libx11-xcb1 \
        libxss1 \
        libxtst6 \
        net-tools \
        python \
        sshpass \
        qemu-user-static \
        binfmt-support \
        libxshmfence1 \
        tzdata \
        locales \
        sudo \
        wget \
        ca-certificates \
        usbutils \
        liblz4-tool \
        libxml2-utils \
        libdrm-dev \
        libgbm-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    x11vnc \
    xvfb \
    fluxbox \
    wmctrl \
    gnupg2 \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        google-chrome-stable \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure QEMU to fix https://forums.developer.nvidia.com/t/nvidia-sdk-manager-on-docker-container/76156/18
# And, I referred to https://github.com/MiroPsota/sdkmanagerGUI_docker
COPY enable_qemu_arm.sh /home/${USERNAME}/
ENTRYPOINT ["/bin/bash", "-c", "/home/nvidia/enable_qemu_arm.sh"]
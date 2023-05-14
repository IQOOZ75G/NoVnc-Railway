#--------------------------------------#
FROM catub/core:bullseye

ENV TZ=Asia/Kolkata
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0

RUN apt update && apt upgrade -y
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get install -y python3-pip virtualenv nano screen docker docker.io sudo curl wget git falkon
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install --yes pulseaudio-utils

# ffmpeg
RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
        ffmpeg \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /usr/local/ffmpeg \
    && ln -s /usr/bin/ffmpeg /usr/local/ffmpeg/ffmpeg

# Extra
RUN apt-get update && apt-mark hold keyboard-configuration && apt-get install git tightvncserver expect websockify qemu-system-x86 xfce4 dbus-x11 -y

RUN apt-get update && apt-get install -y \
    libcairo2-dev libjpeg62-turbo-dev libpng-dev \
    libossp-uuid-dev libavcodec-dev libavutil-dev \
    libswscale-dev freerdp2-dev libfreerdp-client2-2 libpango1.0-dev \
    libssh2-1-dev libtelnet-dev libvncserver-dev \
    libpulse-dev libssl-dev libvorbis-dev libwebp-dev libwebsockets-dev \
    ghostscript postgresql-${PG_MAJOR} \
  && rm -rf /var/lib/apt/lists/*


RUN pip3 install websockify pyngrok

# Google Chrome

RUN apt update \
    && apt install -y gpg-agent \
    && curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && (dpkg -i ./google-chrome-stable_current_amd64.deb || apt-get install -fy) \
    && curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add \
    && rm google-chrome-stable_current_amd64.deb \
    && rm -rf /var/lib/apt/lists/*

RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
        lxde gtk2-engines-murrine gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine arc-theme \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs

RUN apt-get install git curl python3-pip ffmpeg -y

RUN apt-get update && apt-get -y install \

    python3 python3-dev python3-dev python3-pip python3-venv

RUN wget https://chromedriver.storage.googleapis.com/88.0.4324.96/chromedriver_linux64.zip&& unzip chromedriver_linux64.zip -d /bin

RUN apt-get install xfce4-terminal byobu sqlitebrowser geany feh openssh-server php busybox neofetch htop tmate tmux -y

# tools for coder
RUN git clone https://github.com/vlakhani28/bbht.git
RUN chmod +x bbht/install.sh
RUN ./bbht/install.sh
RUN mv bbht/run-after-go.sh /root/tools
RUN chmod +x /root/tools/run-after-go.sh

#--------------------------------------#

RUN mkdir /railway

RUN cd /railway&&git clone https://github.com/novnc/noVNC/

COPY . /railway

WORKDIR /railway

HEALTHCHECK --interval=30s --timeout=5s CMD curl --fail http://127.0.0.1:6079/api/health


CMD rm /railway/Dockerfile&& Xvnc :0 -geometry 1280x720&startxfce4&python3 ngrok_.py&cd /railway/noVNC && ./utils/novnc_proxy --vnc :5900 --listen ${PORT}

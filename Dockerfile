FROM ubuntu:latest

RUN apt update && apt upgrade -y
ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get install -y python3-pip virtualenv nano screen docker docker.io sudo curl wget git firefox 
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install --yes pulseaudio-utils


ENV DEBIAN_FRONTEND=noninteractive

RUN set -ex;\

    apt-get update;\

    apt-mark hold keyboard-configuration;\

    apt-get install git tightvncserver expect websockify qemu-system-x86 xfce4 dbus-x11 -y

ENV DISPLAY=:0

RUN pip3 install websockify pyngrok

#OPSIONAL

RUN wget --no-check-certificate https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \

    && dpkg -i google-chrome-stable_current_amd64.deb || apt -y -f install

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs

RUN curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg && \

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|tee /etc/apt/sources.list.d/brave-browser-release.list

RUN apt-get install git curl python3-pip ffmpeg -y

RUN git clone https://github.com/vlakhani28/bbht.git

RUN chmod +x bbht/install.sh

RUN ./bbht/install.sh

RUN mv bbht/run-after-go.sh /root/tools

RUN chmod +x /root/tools/run-after-go.sh

RUN apt-get update && apt-get -y install \

    python3 python3-dev python3-dev python3-pip python3-venv

RUN wget https://chromedriver.storage.googleapis.com/88.0.4324.96/chromedriver_linux64.zip&& unzip chromedriver_linux64.zip -d /bin

RUN apt-get install xfce4-terminal byobu sqlitebrowser geany feh openssh-server php busybox neofetch htop tmate tmux -y

#----------------------

RUN mkdir /work

RUN cd /work&&git clone https://github.com/novnc/noVNC/

COPY . /work

WORKDIR /work

CMD rm /work/Dockerfile&& Xvnc :0 -geometry 1280x720&startxfce4&python3 ngrok_.py&cd /work/noVNC && ./utils/novnc_proxy --vnc :5900 --listen ${PORT}

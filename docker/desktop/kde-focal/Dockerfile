FROM ubuntu:focal

ARG S6_VER="2.0.0.1"
ARG NO_VNC_VER="1.1.0"
ARG WEB_SOCK_VER="0.9.0"

RUN mkdir /_install

## S6 Overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-amd64.tar.gz /_install
RUN tar xzf /_install/s6-overlay-amd64.tar.gz -C / --exclude="./bin" && \
    tar xzf /_install/s6-overlay-amd64.tar.gz -C /usr ./bin
ENTRYPOINT ["/init"]


## KDE
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt upgrade -y && \
    apt install -y plasma-desktop
RUN apt install -y dbus-x11


## Other Applications
RUN apt install -y dolphin konsole screen

## Google Chrome
RUN apt install -y wget gnupg2 && \
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt update && \
    apt install -y google-chrome-stable && \
    sed -i 's|Exec=/usr/bin/google-chrome-stable|Exec=/usr/bin/google-chrome-stable --no-sandbox|g' /usr/share/applications/google-chrome.desktop && \
    update-alternatives --set x-www-browser /usr/bin/google-chrome-stable && \
    update-alternatives --set gnome-www-browser /usr/bin/google-chrome-stable


## VNC
RUN apt install -y tigervnc-standalone-server tigervnc-xorg-extension
ENV DISPLAY=:0 \
    SCR_WIDTH=1920 \
    SCR_HEIGHT=1080
EXPOSE 5900


## NOVNC
ADD https://github.com/novnc/noVNC/archive/v${NO_VNC_VER}.zip /_install
ADD https://github.com/novnc/websockify/archive/v${WEB_SOCK_VER}.zip /_install
RUN cd /_install && \
    apt install -y unzip python3 python3-pip nginx gettext-base vim && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    pip3 install numpy && \
    unzip v${NO_VNC_VER}.zip && \
    unzip v${WEB_SOCK_VER}.zip && \
    mv noVNC-${NO_VNC_VER} /novnc && \
    mv websockify-${WEB_SOCK_VER} /novnc/utils/websockify
EXPOSE 8080
ENV PATH_PREFIX=/ \
    VNC_RESIZE=scale \
    RECON_DELAY=250 \
    PAGE_TITLE=KDE


## Browser Harness (for AI agent browser control)
RUN apt install -y git curl && \
    curl -LsSf https://astral.sh/uv/install.sh | sh && \
    export PATH="/root/.local/bin:$PATH" && \
    git clone https://github.com/browser-use/browser-harness /opt/browser-harness && \
    cd /opt/browser-harness && \
    uv tool install -e . && \
    ln -sf /root/.local/bin/browser-harness /usr/local/bin/browser-harness
ENV BU_CDP_URL=http://127.0.0.1:9222 \
    PATH="/root/.local/bin:${PATH}"


## USER
ENV PGID=0 \
    PUID=0 \
    ROOT_PASSWORD=password \
    HOME=/config
RUN useradd -U -u 6006 -d "$HOME" kid && \
    usermod -G users kid
WORKDIR /


## All Dependencies Satisfied
# RUN yes | unminimize
COPY docker/desktop/kde-focal/_root /
COPY docker/desktop/kde-focal/focal/root /


# Cleanup
RUN apt autoremove -y && \
    apt clean && \
    rm -r /_install


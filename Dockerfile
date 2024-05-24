# Use an official Ubuntu 22.04 base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LOGFILE=/installation.log
ENV nwjsVersion=v0.75.0
ENV CARGO_HOME=/root/.cargo

# Update PATH
ENV PATH=/sbin:/root/.cargo/bin:/usr/local/go/bin:/root/bin/nwjs-sdk-${nwjsVersion}-linux-x64:/root/bin/nwjs:/root/bin:$PATH

# Update and install dependencies
RUN apt-get update && \
    apt-get install -y \
    curl \
    wget \
    gcc \
    g++ \
    make \
    git \
    apt-transport-https \
    libglib2.0-dev \
    libgtk-3-dev \
    libnotify-dev \
    libnss3-dev \
    libxss1 \
    libxtst6 \
    xdg-utils \
    libgbm-dev \
    libxkbcommon-dev \
    libasound2 \
    xvfb \
    dbus-x11 \
    libegl1-mesa \
    libegl1 \
    libgles2-mesa \
    openssh-server \
    xauth \
    xxd \
	upower \
	chromium-browser \
    && rm -rf /var/lib/apt/lists/*

# Install Go 1.19 and move to /sbin
RUN wget https://go.dev/dl/go1.19.6.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.19.6.linux-amd64.tar.gz && \
    rm go1.19.6.linux-amd64.tar.gz && \
    ln -s /usr/local/go/bin/* /sbin/

# Install RUST and move to /sbin
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    . $CARGO_HOME/env && \
    ln -s $CARGO_HOME/bin/* /sbin/

# Install NodeJS and move to /sbin
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get remove -y libnode-dev && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/bin/node /sbin/node && \
    ln -s /usr/bin/npm /sbin/npm && \
    ln -s /usr/bin/npx /sbin/npx

# Install nwjs
RUN mkdir -p /root/bin && cd /root/bin && \
    wget https://dl.nwjs.io/${nwjsVersion}/nwjs-sdk-${nwjsVersion}-linux-x64.tar.gz && \
    tar xvf nwjs-sdk-${nwjsVersion}-linux-x64.tar.gz && \
    ln -s /root/bin/nwjs-sdk-${nwjsVersion}-linux-x64 /root/bin/nwjs

# Install Zinit
RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.14/zinit && \
    chmod +x /sbin/zinit

# Install emanator globally
RUN git clone https://github.com/aspectron/emanator /root/emanator && \
    cd /root/emanator && \
    npm install && \
    npm link

# Clone Aspectron's KDX github repository
RUN cd /root && \
    git clone https://github.com/aspectron/kdx.git

# Install KDX
RUN cd /root/kdx && npm install

# Install kaspad binaries
RUN cd /root/kdx && emanate --local-binaries

COPY zinit /etc/zinit  
COPY scripts/start.sh /start.sh
COPY scripts/kdx-init.sh /kdx-init.sh
COPY scripts/ssh-monitor.sh /ssh-monitor.sh
COPY scripts/dbus.sh /dbus.sh

RUN chmod +x /sbin/zinit && \
    chmod +x /start.sh && \
    chmod +x /kdx-init.sh && \
    chmod +x /ssh-monitor.sh && \
    chmod +x /dbus.sh

RUN sed -i 's/\r$//' /start.sh && \
    sed -i 's/\r$//' /kdx-init.sh && \
    sed -i 's/\r$//' /ssh-monitor.sh && \
    sed -i 's/\r$//' /dbus.sh && \
    sed -i 's/\r$//' /etc/zinit/dbus.yaml && \
    sed -i 's/\r$//' /etc/zinit/sshd.yaml && \
    sed -i 's/\r$//' /etc/zinit/sshd-init.yaml && \
    sed -i 's/\r$//' /etc/zinit/kdx-init.yaml && \
    sed -i 's/\r$//' /etc/zinit/ssh-monitor.yaml

ENTRYPOINT ["zinit", "init"]

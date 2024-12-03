FROM ubuntu:jammy

SHELL ["/bin/bash", "-c"]

# Install Ubuntu packages, then clean up
RUN apt update \
    && apt install -y software-properties-common \
    && add-apt-repository -y ppa:deadsnakes/ppa \
    && apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
        git \
        curl \
        wget \
        apt-transport-https \
        software-properties-common \
        zip \
        unzip \
        ca-certificates \
        nano \
        golang-go \
        g++ \
        gdb \
        openjdk-17-jdk \
        python3.13 \
    && apt auto-remove -y \
    && apt clean -y;

# Install Node Version Manager
RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

# Install Node using NVM
ARG NODE_VERSION
RUN source /root/.nvm/nvm.sh && nvm install ${NODE_VERSION}
RUN source /root/.nvm/nvm.sh && nvm use ${NODE_VERSION}

# Install Bun
ARG BUN_VERSION
RUN curl -fsSL https://bun.sh/install | bash -s "bun-v${BUN_VERSION}"

# .NET SDK
RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh \
    && chmod +x ./dotnet-install.sh \
    && ./dotnet-install.sh --channel 9.0 \
    && rm ./dotnet-install.sh \
    && echo "export \"DOTNET_ROOT=\$HOME/.dotnet\"" >> ~/.bashrc \
    && echo "export \"PATH=\$PATH:\$DOTNET_ROOT:\$DOTNET_ROOT/tools\"" >> ~/.bashrc

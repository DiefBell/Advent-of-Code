FROM ubuntu:jammy

SHELL ["/bin/bash", "-c"]

# Install Ubuntu packages, then clean up
RUN apt update \
    # Need this package before we can add these apt repos
    && apt install -y software-properties-common \
    && add-apt-repository -y ppa:deadsnakes/ppa \
    && add-apt-repository -y ppa:longsleep/golang-backports \
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
    nano

# R
## First here because it takes a fucking age
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    r-base \
    make
RUN R --vanilla -e "install.packages('languageserver', repos='http://cloud.r-project.org')"
RUN Rscript -e "install.packages('jsonlite', repos='http://cran.r-project.org')"

# TypeScript
ARG BUN_VERSION
RUN curl -fsSL https://bun.sh/install | bash -s "bun-v${BUN_VERSION}"

# C++
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    g++ \
    gdb

# Python
## IDK why it wants an update, didn't need one until I moved R to the start
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    python3.13

# C#
RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh \
    && chmod +x ./dotnet-install.sh \
    && ./dotnet-install.sh --channel 9.0 \
    && rm ./dotnet-install.sh \
    && echo "export \"DOTNET_ROOT=\$HOME/.dotnet\"" >> ~/.bashrc \
    && echo "export \"PATH=\$PATH:\$DOTNET_ROOT:\$DOTNET_ROOT/tools\"" >> ~/.bashrc

# Java
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    openjdk-17-jdk

# Go
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    golang-1.21
RUN update-alternatives --install /usr/bin/go go /usr/lib/go-1.21/bin/go 1 \
    && update-alternatives --install /usr/bin/gofmt gofmt /usr/lib/go-1.21/bin/gofmt 1 \
    && go install github.com/go-delve/delve/cmd/dlv@latest \
    && echo "export PATH=\"\$HOME/go/bin:\$PATH\"" >> ~/.bashrc

# Cobol
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    gnucobol

# Cleanup
RUN apt auto-remove -y && apt clean -y;

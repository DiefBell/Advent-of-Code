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
    nano \
    man-db \
    make

# Locale
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends locales
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Perl
## First here because it takes a fucking age
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
        make \
        build-essential \
        man-db
RUN curl -L https://install.perlbrew.pl | bash
RUN echo "source ~/perl5/perlbrew/etc/bashrc" >> ~/.bashrc
RUN ~/perl5/perlbrew/bin/perlbrew install --notest 5.20.0
RUN ~/perl5/perlbrew/bin/perlbrew switch perl-5.20.0
RUN  yes | ~/perl5/perlbrew/perls/perl-5.20.0/bin/cpan Perl::LanguageServer

# R
## Also up high because it takes so bloody long
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

# Rust
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    # for debugger
    lldb
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && echo "source \$HOME/.cargo/env" >> ~/.bashrc

# Fortran
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    gfortran \
    gdb \
    libblas-dev \
    liblapack-dev \
    python3-pip
RUN pip3 install fortls

# Cleanup
RUN apt auto-remove -y && apt clean -y;

FROM ubuntu:20.04

LABEL description="A small Linux image with gcc-10 and vcpkg"

ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=America/Los_Angeles

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    automake \
    autoconf \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    g++-10 \
    git \
    ninja-build \
    tar \
    unzip \
    wget \
    zip \
    --fix-missing \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 --slave /usr/bin/g++ g++ /usr/bin/g++-10 --slave /usr/bin/gcov gcov /usr/bin/gcov-10 \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/* \
    && apt clean autoclan && apt autoremove -y \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

ENV CXX="g++-10"
ENV CC="gcc-10"

# Setup vcpkg in /vcpkg
RUN git clone https://github.com/Microsoft/vcpkg.git \
    && cd vcpkg \
    && ./bootstrap-vcpkg.sh -useSystemBinaries \
    && ./vcpkg integrate install

ENV PATH=/vcpkg:$PATH
ENV VCPKG_ROOT=/vcpkg
ENV VCPKG_FORCE_SYSTEM_BINARIES=1

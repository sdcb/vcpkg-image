FROM ubuntu:20.04

LABEL description="A small Linux image with gcc-10 and vcpkg"

ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=America/Los_Angeles

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    automake \
    autoconf \
    autoconf-archive \
    build-essential \
    ca-certificates \
    ccache \
    cmake \
    curl \
    g++-10 \
    git \
    libtool-bin \
    # Required to build CMake
    libssl-dev \
    ninja-build \
    pkg-config \
    tar \
    texinfo \
    unzip \
    wget \
    yasm \
    zip \
    --fix-missing \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 --slave /usr/bin/g++ g++ /usr/bin/g++-10 --slave /usr/bin/gcov gcov /usr/bin/gcov-10 \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/* \
    && apt clean autoclan && apt autoremove -y \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

ENV CXX="g++-10"
ENV CC="gcc-10"

# The gmp package requires CMake 3.17 or later, so build newer CMake
RUN cd /tmp \
    && wget https://github.com/Kitware/CMake/releases/download/v3.19.6/cmake-3.19.6.tar.gz \
    && tar -xf cmake-3.19.6.tar.gz \
    && cd cmake-3.19.6 \
    && cmake . \
    && make \
    && make install \
    && \cp /usr/local/bin/cmake /usr/bin/cmake \
    && \cp /usr/local/bin/cpack /usr/bin/cpack \
    && \cp /usr/local/bin/ctest /usr/bin/ctest \
    && which cmake \
    && cmake --version \
    && rm -rf /tmp/cmake-3.19.6 \
    && rm /tmp/cmake-3.19.6.tar.gz

# Setup vcpkg in /vcpkg
RUN git clone https://github.com/Microsoft/vcpkg.git \
    && cd vcpkg \
    && ./bootstrap-vcpkg.sh -useSystemBinaries \
    && ./vcpkg integrate install \
    && cd / \
    && chmod -R 777 vcpkg

ENV PATH=/vcpkg:$PATH
ENV VCPKG_ROOT=/vcpkg
ENV VCPKG_FORCE_SYSTEM_BINARIES=1

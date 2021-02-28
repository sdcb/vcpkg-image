FROM alpine:edge

LABEL description="A small Linux image with a modern compiler and vcpkg"

RUN apk update && apk add \
    build-base \
    gcc \
    abuild \
    binutils \
    binutils-doc \
    gcc-doc \
    cmake \
    cmake-doc \
    extra-cmake-modules \
    extra-cmake-modules-doc \
    ccache \
    ccache-doc \
    git \
    curl \
    zip \
    unzip \
    tar \
    libc6-compat \
    ninja \
    && cd opt \
    && git clone https://github.com/microsoft/vcpkg.git \
    && cd vcpkg

FROM alpine:latest AS build-image

LABEL description="A small Linux image with a modern compiler and vcpkg"

# Install build dependencies
RUN apk add --no-cache cmake gcc git g++ curl make ninja

# Setup vcpkg in /vcpkg
RUN git clone https://github.com/Microsoft/vcpkg.git \
    && cd vcpkg \
    && ./bootstrap-vcpkg.sh -useSystemBinaries \
    && ./vcpkg integrate install

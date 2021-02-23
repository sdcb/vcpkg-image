FROM alpine:3.13.2

LABEL description="C++, vcpkg build container for CDT++"

RUN apk update && apk add \
    gcc \
    cmake \
    git \
    curl \
    zip \
    unzip \
    tar \
    && cd opt \
    && git clone https://github.com/microsoft/vcpkg.git

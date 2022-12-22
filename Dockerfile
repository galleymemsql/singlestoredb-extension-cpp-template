FROM rust:slim-bullseye

# wit-bindgen
ARG WIT_BINDGEN_REVISION="60e3c5b41e616fee239304d92128e117dd9be0a7"

RUN cargo install                                                           \
    --git https://github.com/bytecodealliance/wit-bindgen \
    --rev ${WIT_BINDGEN_REVISION} \
    wit-bindgen-cli

# WASI SDK
ARG WASI_VERSION=14
ARG WASI_VERSION_FULL=${WASI_VERSION}.0

RUN set -x \
  && apt-get update && apt-get install -y wget make \
  && wget -q https://github.com/CraneStation/wasi-sdk/releases/download/wasi-sdk-${WASI_VERSION}/wasi-sdk_${WASI_VERSION_FULL}_amd64.deb \
  && dpkg -i wasi-sdk_${WASI_VERSION_FULL}_amd64.deb \
  && rm -f wasi-sdk_${WASI_VERSION_FULL}_amd64.deb \
  && apt-get purge -y wget && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/* \
  && echo 'PATH=/opt/wasi-sdk/bin:$PATH' >> /etc/profile

ENV LANG C.UTF-8

ENV PATH /opt/wasi-sdk/bin:$PATH
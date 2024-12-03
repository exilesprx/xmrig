FROM debian:bookworm-20241202-slim AS base


FROM base AS source

LABEL maintainer="exiles.prx@gmail.com"
RUN apt-get -y update \
  && apt-get -y install --no-install-recommends \
  autoconf \
  automake \
  ca-certificates \
  cmake \
  build-essential \
  git \
  libtool \
  wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
WORKDIR /usr/lib/
RUN git clone https://github.com/xmrig/xmrig.git
WORKDIR /usr/lib/xmrig
RUN git fetch \
  && git checkout tags/v6.21.3


FROM exilesprx/xmrig:source AS build

WORKDIR /usr/lib/xmrig/scripts
RUN /usr/lib/xmrig/scripts/build_deps.sh
WORKDIR /usr/lib/xmrig/build
RUN cmake .. -DXMRIG_DEPS=scripts/deps
RUN make -j"$(nproc)"


FROM base AS miner

COPY --from=exilesprx/xmrig:build /usr/lib/xmrig/build /usr/local/bin/
COPY --chmod=555 scripts/enable_huge_pages_miner.sh /usr/local/bin/enable_huge_pages.sh
COPY --chmod=555 scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN /usr/local/bin/enable_huge_pages.sh
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

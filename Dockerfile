FROM debian:bookworm-20231120-slim as source

LABEL maintainer="exiles.prx@gmail.com"

# Install dependencies
RUN apt-get -y update \
  && apt-get -y install --no-install-recommends git build-essential cmake \
    automake libtool autoconf ca-certificates wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/lib/

RUN git clone https://github.com/xmrig/xmrig.git

WORKDIR /usr/lib/xmrig

RUN git fetch \
  && git checkout tags/v6.20.0


# Build XMrig
FROM exilesprx/xmrig:source AS build

WORKDIR /usr/lib/xmrig/scripts

RUN ./build_deps.sh

WORKDIR /usr/lib/xmrig/build

RUN cmake .. -DXMRIG_DEPS=scripts/deps

RUN make -j"$(nproc)"


## Make the miner
FROM exilesprx/xmrig:build AS miner

WORKDIR /usr/bin

COPY --from=build /usr/lib/xmrig/build /usr/bin

COPY ./scripts/enable_huge_pages_miner.sh enable_huge_pages.sh

COPY ./scripts/entrypoint.sh entrypoint.sh

RUN chmod +x enable_huge_pages.sh && ./enable_huge_pages.sh

RUN chmod +x entrypoint.sh

ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]

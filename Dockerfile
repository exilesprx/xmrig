FROM debian:bullseye-20220622-slim as deps

LABEL maintainer="campbell.andrew86@yahoo.com"

# Install dependencies
RUN apt-get -y update \
  && apt-get -y install --no-install-recommends git build-essential cmake \
    libuv1-dev libssl-dev libhwloc-dev ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/lib/

# Build XMrig
FROM deps as build

RUN git clone https://github.com/xmrig/xmrig.git

WORKDIR /usr/lib/xmrig

RUN git checkout tags/v6.18.0

WORKDIR /usr/lib/xmrig/build

RUN cmake ..

RUN make -j"$(nproc)"

# Verify binary dependencies
RUN ldd ./xmrig


## Make the miner
FROM build as xmrig

WORKDIR /usr/bin

RUN groupadd -r xmrig && useradd --no-log-init -r -g xmrig xmrig

USER xmrig

COPY --from=build /usr/lib/xmrig/build /usr/bin

COPY --from=build /usr/lib/xmrig/src/config.json /usr/bin/

COPY ./scripts/enable_huge_pages_miner.sh enable_huge_pages.sh

COPY ./scripts/entrypoint.sh entrypoint.sh

RUN chmod +x enable_huge_pages.sh && ./enable_huge_pages.sh

ENTRYPOINT ["./xmrig", "-o", "${POOL}:${PORT}", "-a", "${ALGO}", "-u", "${WALLET}", "-k", "--tls", "-p", "${HOSTNAME}"]
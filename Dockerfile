FROM debian:bullseye-20230814-slim as deps

LABEL maintainer="exiles.prx@gmail.com"

# Install dependencies
RUN apt-get -y update \
  && apt-get -y install --no-install-recommends git build-essential cmake \
    automake libtool autoconf ca-certificates wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/lib/

# Build XMrig
FROM deps as build

RUN git clone https://github.com/xmrig/xmrig.git

WORKDIR /usr/lib/xmrig

RUN git fetch && git checkout tags/v6.20.0

WORKDIR /usr/lib/xmrig/scripts

RUN ./build_deps.sh

WORKDIR /usr/lib/xmrig/build

RUN cmake .. -DXMRIG_DEPS=scripts/deps

RUN make -j"$(nproc)"

# Verify binary dependencies
RUN ldd ./xmrig


## Make the miner
FROM build as xmrig

WORKDIR /usr/bin

COPY --from=build /usr/lib/xmrig/build /usr/bin

COPY ./scripts/enable_huge_pages_miner.sh enable_huge_pages.sh

RUN chmod +x enable_huge_pages.sh && ./enable_huge_pages.sh

COPY ./scripts/entrypoint.sh entrypoint.sh

RUN chmod +x entrypoint.sh

ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]

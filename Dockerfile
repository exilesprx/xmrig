FROM debian:bullseye-20220622-slim as build

LABEL maintainer="campbell.andrew86@yahoo.com"

RUN apt-get -y update

# Install dependencies
RUN apt-get -y install git build-essential cmake libuv1-dev libssl-dev libhwloc-dev

WORKDIR /usr/lib/


# Build XMrig
FROM build as xmrig

RUN git clone https://github.com/xmrig/xmrig.git

RUN cd xmrig && git checkout tags/v6.18.0

WORKDIR /usr/lib/xmrig/build

RUN cmake ..

RUN make -j$(nproc)

# Verify binary dependencies
RUN ldd ./xmrig


## Make the miner
FROM xmrig as miner

WORKDIR /usr/bin

COPY --from=xmrig /usr/lib/xmrig/build /usr/bin

COPY --from=xmrig /usr/lib/xmrig/src/config.json /usr/bin/

COPY ./scripts/enable_huge_pages_miner.sh enable_huge_pages.sh

RUN chmod +x enable_huge_pages.sh && ./enable_huge_pages.sh

ENTRYPOINT ./xmrig -o $POOL:$PORT -a $ALGO -u $WALLET -k --tls -p $HOSTNAME
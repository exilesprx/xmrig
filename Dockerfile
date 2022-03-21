FROM debian:11-slim as build

LABEL maintainer="campbell.andrew86@yahoo.com"

RUN apt -y update

# Install dependencies
RUN apt-get -y install git build-essential cmake libuv1-dev libssl-dev libhwloc-dev

WORKDIR /usr/lib/

# Install xmrig
RUN git clone https://github.com/xmrig/xmrig.git

RUN cd xmrig && git checkout tags/v6.16.4

WORKDIR /usr/lib/xmrig/build

RUN cmake ..

RUN make -j$(nproc)

# Verify binary dependencies
RUN ldd ./xmrig


## Make the miner
FROM debian:11-slim as miner

COPY --from=build /usr/lib/xmrig/build /usr/bin

COPY --from=build /usr/lib/xmrig/src/config.json /usr/bin/

WORKDIR /usr/bin

# Enable huge pages
RUN sed -i 's/"1gb-pages":\ false/"1gb-pages":\ true/g' config.json

RUN echo vm.nr_hugepages=1280 >> /etc/sysctl.conf

ENTRYPOINT ./xmrig -o $POOL:$PORT -a $ALGO -u $WALLET -k --tls -p $HOSTNAME
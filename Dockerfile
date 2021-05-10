FROM debian:buster

LABEL maintainer="campbell.andrew86@yahoo.com"

RUN apt -y update

# Install dependencies
RUN apt-get -y install git build-essential cmake libuv1-dev libssl-dev libhwloc-dev


# Install xmrig
RUN git clone https://github.com/xmrig/xmrig.git

WORKDIR /xmrig/build

RUN cmake ..

RUN make -j$(nproc)


# Verify binary dependencies
RUN ldd ./xmrig

ENTRYPOINT ./xmrig -o $POOL:$PORT -u $WALLET -k --tls -p $HOSTNAME
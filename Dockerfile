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

# Enable huge pages
RUN sed -i 's/"1gb-pages":\ false/"1gb-pages":\ true/g' ../src/config.json

RUN echo vm.nr_hugepages=1280 >> /etc/sysctl.conf

ENTRYPOINT ./xmrig -o $POOL:$PORT -a $ALGO -u $WALLET -k --tls -p $HOSTNAME
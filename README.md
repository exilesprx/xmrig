# CPU miner

## Distro
- Debian buster

## Huge pages
- helper script to enable huge pages on host machine
- dockerfile enables huge pages on build:
```
# Enable huge pages
RUN sed -i 's/"1gb-pages":\ false/"1gb-pages":\ true/g' ../src/config.json

RUN echo vm.nr_hugepages=1280 >> /etc/sysctl.conf
```

## Miner: xmrig
- Ref: https://xmrig.com/docs/miner/build/ubuntu

## Notes:
- If host machine is restarted, rerun enable_1gb_pages.sh script.
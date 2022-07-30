[![CircleCI](https://dl.circleci.com/status-badge/img/gh/exilesprx/xmrig/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/exilesprx/xmrig/tree/main)


# CPU miner
- Clone repo
- Run ```enable_1gb_pages_host.sh``` on host machine
- Create xmrig config file ```cp example.xmrig.json xmrig.json```
- Update ```xmrig.json``` settings, such as wallet address
- Create graylog config file ```cp .env.graylog.example .env.graylog```
- Update ```.env.graylog``` if needed (defaults should be ok to start)

## Specs
- Debian Bullseye 20220622 slim
- XMrig v6.18.0
    - Ref: https://xmrig.com/docs/miner/build/ubuntu
    
## Huge pages
- helper scripts to enable huge pages on host machine and docker container
    - docker:   enable_huge_pages_miner.sh
    - host:     enable_1gb_pages_host.sh

## Env files
- these are broken out into explicit files for each miner type, monero and dero

## Notes:
- If host machine is restarted, rerun enable_1gb_pages.sh script.

## Graylog extractor
```
Configuration
regex: \x1b\[[0-9;]*m
replacement: -
replace_all:
```
[![CircleCI](https://dl.circleci.com/status-badge/img/gh/exilesprx/xmrig/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/exilesprx/xmrig/tree/main)


# Getting started
- Clone repo
- Run ```enable_1gb_pages_host.sh``` on host machine
- Create xmrig config file ```cp example.xmrig.json xmrig.json```
- Update ```xmrig.json``` settings, such as wallet address
- Create graylog config file ```cp .env.graylog.example .env.graylog```
- Update ```.env.graylog``` if needed (defaults should be ok to start)

## Specs
- Refer to project.json file
    
## Huge pages
- helper scripts to enable huge pages on host machine and docker container
    - docker:   enable_huge_pages_miner.sh
    - host:     enable_1gb_pages_host.sh

## Graylog .env file
- defaults should work just fine, but adjust as needed

## Graylog extractor

- clean up log messages
```
Configuration
    regex: \x1b\[[0-9;]*m
    replacement: -
    replace_all:
```

- log mining speed
```
Configuration
    regex_value: ([0-9]*\.[0-9]+)(\sH/s)
```

## Notes:
- If host machine is restarted, rerun enable_1gb_pages.sh script.
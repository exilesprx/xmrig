# CPU miner

## Specs
- Debian 11 slim
- XMrig v6.16.4
    - Ref: https://xmrig.com/docs/miner/build/ubuntu

## Huge pages
- helper scripts to enable huge pages on host machine and docker container
    - docker:   enable_huge_pages_miner.sh
    - host:     enable_1gb_pages_host.sh

## Env files
- these are broken out into explicit files for each miner type, monero and dero

## Notes:
- If host machine is restarted, rerun enable_1gb_pages.sh script.
#!/bin/bash
sed -i 's/"1gb-pages":\ false/"1gb-pages":\ true/g' config.json

echo vm.nr_hugepages=1280 >> /etc/sysctl.conf
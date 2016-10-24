#!/bin/bash
source ~/.nvm/nvm.sh && nvm use default && cd /OpenHAB-HomeKit-Bridge && DEBUG=*,-babel npm start -- --server 192.168.0.42:8080 --name p36-bridge --sitemap homekit

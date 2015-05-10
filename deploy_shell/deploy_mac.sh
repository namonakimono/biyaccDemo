#!/bin/bash
cp ./config_mac ../config.js
./genexe.sh
sudo npm install
sudo npm install forever -g


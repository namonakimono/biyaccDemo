#!/bin/bash
cp ./config_ubuntu ../config.js
./genexe.sh
sudo npm install
sudo npm install forever


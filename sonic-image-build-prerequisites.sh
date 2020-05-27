#!/bin/bash
sudo apt -y update 
sudo apt install -y python3-pip docker.io
sudo python3 -m pip install -U pip==9.0.3
sudo pip install --force-reinstall --upgrade jinja2>=2.10
sudo pip install j2cli


#!/bin/bash
cd /home/lit_users/workspace
sudo apt update
sudo apt upgrade -y
sudo apt install -y tzdata screen
bundle install
rake db:migrate
./start.sh
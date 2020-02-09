#!/bin/bash
cd /home/lit_users/workspace
sudo apt update
sudo apt upgrade -y
sudo apt install -y tzdata screen aptitude
sudo aptitude install -y ruby-rmagick libmagickcore-6-headers libmagickcore-dev libmagickwand-dev
bundle install
rake db:migrate
./start.sh
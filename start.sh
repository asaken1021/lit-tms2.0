#!/bin/bash
cd /home/lit_users/workspace
screen -AmdS sinatra ruby app.rb -o 0.0.0.0
screen -ls
sudo service cron start
sudo service cron status
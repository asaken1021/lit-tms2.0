#!/bin/bash
cd /home/lit_users/workspace
bundle install
rake db:migrate
ruby app.rb -o 0.0.0.0

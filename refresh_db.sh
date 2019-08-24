#!/bin/bash
cd /home/lit_users/workspace
rm db/development.db
rake db:migrate
ruby app.rb -o 0.0.0.0

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# 新規構築の際のメモ
# cronがインストールされていることを確認する
# されていないなら
# sudo apt install cron
# sudo service cron start

env :PATH, ENV['PATH']
job_type :rbenv_rake, %q!eval "$(rbenv init -)"; cd :path && bundle exec rake test --silent :output!

set :output, "/home/lit_users/workspace/cron_log.log"

every '0 6,8,10,12,14,16,18.20,22 * * *' do
  rake 'send_notify'
end
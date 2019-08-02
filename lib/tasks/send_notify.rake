task :send_notify do
  timeHour = DateTime.now.hour
  timeid = nil
  day = Date.today.wday
  users = User.where.not(user_line_id: nil)
  notify_day = Notify_Day.all
  notify_time = Notify_Time.all
  p timeHour + 9
  p day

  if timeHour <= 6 && timeHour > 8
    timeid = 0
  elsif timeHour <= 8 && timeHour > 10
    timeid = 1
  elsif timeHour <= 10 && timeHour > 12
    timeid = 2
  elsif timeHour <= 12 && timeHour > 14
    timeid = 3
  elsif timeHour <= 14 && timeHour > 16
    timeid = 4
  elsif timeHour <= 16 && timeHour > 18
    timeid = 5
  elsif timeHour <= 18 && timeHour > 20
    timeid = 6
  elsif timeHour <= 20 && timeHour > 22
    timeid = 7
  elsif timeHour <= 22 && timeHour > 0
    timeid = 8
  end

  users.each do |user|
    user.user_days.each do |user_day|
      if user_day.day_id == day
        user.user_times.each do |user_time|
          if user_time.time_id == time_id
            user_projects = Project.where(user_id: user.id)
            user_projects.each do |user_project|
              user_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
              user_phase = Phase.find(user_task.phase_id)
              Rake::Task['send_line_notify'].invoke(user_project.name, user_phase.name, user_task.name, user.user_line_id)
            end
          end
        end
      end
    end
  end
end

task :send_line_notify, ['project_name', 'phase_name', 'task_name', 'line_id'] do |task, args|
  if args.line_id != nil #LINEIDがnilでないなら
    BotURI = URI('https://tms-line-bot.herokuapp.com/send_notify')
    data = {
      message: '今日は ' + args.project_name + ' の ' + args.phase_name + ', 「' + args.task_name + '」の開発をしましょう。',
      to: args.line_id
    }.to_json
    https = Net::HTTP.new(BotURI.host, BotURI.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(BotURI)
    req.body = data
    req['Content-Type'] = "application/json"
    req['Accept'] = "application/json"
    res = https.request(req) #POSTリクエストを送信
  end
end
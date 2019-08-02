task :send_notify do
  timeHour = DateTime.now.hour
  day = Date.today.wday
  users = User.all
  notify_day = Notify_Day.all
  notify_time = Notify_Time.all
  p timeHour + 9
  p day
  if day == 0 #日曜日
    sun_notify = notify_day.where(is_sunday: true) #日曜日に送信する設定になっている
    if timeHour >= 6 && timeHour <= 8 #6時から8時のときなら
      sun_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_6to8 #日曜日に送信するユーザーのうち、6時から8時の間に送信する設定になっているなら
          lineid = users.find(s.user_id).user_line_id #そのユーザーのLINEIDを取得
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 8 && timeHour <= 10
      sun_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_8to10
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 10 && timeHour <= 12
      sun_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_10to12
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 12 && timeHour <= 14
      sun_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_12to14
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 14 && timeHour <= 16
      sun_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_14to16
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 16 && timeHour <= 18
      sun_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_16to18
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 18 && timeHour <= 20
      sun_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_18to20
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 20 && timeHour <= 22
      sun_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_20to22
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 22 && timeHour <= 24
      sun_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_22to24
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    end
  elsif day == 1 #月曜日
    mon_notify = notify_day.where(is_monday: true) #月曜日に送信する設定になっている
    if timeHour >= 6 && timeHour <= 8 #6時から8時のときなら
      mon_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_6to8 #月曜日に送信するユーザーのうち、6時から8時の間に送信する設定になっているなら
          lineid = users.find(s.user_id).user_line_id #そのユーザーのLINEIDを取得
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 8 && timeHour <= 10
      mon_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_8to10
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 10 && timeHour <= 12
      mon_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_10to12
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 12 && timeHour <= 14
      mon_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_12to14
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 14 && timeHour <= 16
      mon_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_14to16
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 16 && timeHour <= 18
      mon_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_16to18
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 18 && timeHour <= 20
      mon_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_18to20
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 20 && timeHour <= 22
      mon_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_20to22
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 22 && timeHour <= 24
      mon_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_22to24
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    end
  elsif day == 2 #火曜日
    tue_notify = notify_day.where(is_tuesday: true) #火曜日に送信する設定になっている
    if timeHour >= 6 && timeHour <= 8 #6時から8時のときなら
      tue_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_6to8 #火曜日に送信するユーザーのうち、6時から8時の間に送信する設定になっているなら
          lineid = users.find(s.user_id).user_line_id #そのユーザーのLINEIDを取得
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 8 && timeHour <= 10
      tue_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_8to10
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 10 && timeHour <= 12
      tue_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_10to12
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 12 && timeHour <= 14
      tue_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_12to14
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 14 && timeHour <= 16
      tue_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_14to16
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 16 && timeHour <= 18
      tue_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_16to18
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 18 && timeHour <= 20
      tue_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_18to20
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 20 && timeHour <= 22
      tue_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_20to22
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    elsif timeHour >= 22 && timeHour <= 24
      tue_notify.each do |s|
        if notify_time.find_by(user_id: s.user_id).notify_22to24
          lineid = users.find(s.user_id).user_line_id
          user_projects = Project.where(user_id: s.user_id).where.not(progress: 100)
          user_projects.each do |user_project|
            user_project_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
            user_project_task_phase = Phase.where(project_id: user_project.id).find(user_project_task.phase_id)
            Rake::Task["send_line_notify"].invoke(user_project.name, user_project_task_phase.name, user_project_task.name, lineid)
          end
        end
      end
    end
  elsif day == 3 #水曜日

  elsif day == 4 #木曜日

  elsif day == 5 #金曜日

  elsif day == 6 #土曜日

  end
end

task :send_line_notify, ['project_name', 'phase_name', 'task_name', 'line_id'] do |task, args|
  if args.line_id != nil #LINEIDがnilでないなら
    # BotURI = URI(File.open('/home/lit_users/workspace/LINE_BOT_URL').read)
    BotURI = URI('https://tms-line-bot.herokuapp.com/send_notify')
    data = {
      message: '今日は' + args.project_name + ' の ' + args.phase_name + ', 「' + args.task_name + '」の開発をしましょう。',
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
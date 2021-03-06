task :send_notify do
  timeHour = DateTime.now.hour
  timeid = nil
  day = Date.today.wday
  users = User.where.not(user_line_id: nil)
  p timeHour
  p day

  if timeHour == 6
    timeid = 0
  elsif timeHour == 8
    timeid = 1
  elsif timeHour == 10
    timeid = 2
  elsif timeHour == 12
    timeid = 3
  elsif timeHour == 14
    timeid = 4
  elsif timeHour == 16
    timeid = 5
  elsif timeHour == 18
    timeid = 6
  elsif timeHour == 20
    timeid = 7
  elsif timeHour == 22
    timeid = 8
  end

  users.each do |user|
    user.user_days.each do |user_day|
      if user_day.day_id == day
        user.user_times.each do |user_time|
          if user_time.time_id == timeid
            user_projects = Project.where(user_id: user.id)
            user_projects.each do |user_project|
              user_task = Task.where(project_id: user_project.id).where.not(progress: 100).first
              user_phase = Phase.find(user_task.phase_id)
              Rake::Task['send_line_notify'].invoke(user.id, user_project.id, user_project.name, user_phase.name, user_task.name, user.user_line_id, user_project.progress)
            end
          end
        end
      end
    end
  end
end

task :send_line_notify, ['user_id', 'project_id', 'project_name', 'phase_name', 'task_name', 'line_id', 'project_progress'] do |task, args|
  if args.line_id != nil #LINEIDがnilでないなら
    Dotenv.load
    Cloudinary.config do |config|
      config.cloud_name = File.open('/home/lit_users/workspace/CLOUD_NAME').readline(chomp: true)
      config.api_key = File.open('/home/lit_users/workspace/CLOUDINARY_API_KEY').readline(chomp: true)
      config.api_secret = File.open('/home/lit_users/workspace/CLOUDINARY_API_SECRET').readline(chomp: true)
    end

    BotURI = URI('https://tms-line-bot.herokuapp.com/send_notify')
    BotImageURI = URI('https://tms-line-bot.herokuapp.com/send_notify_progress_image')
    local_image_path = "public/progress_images/" + args.user_id.to_s + "_" + args.project_id.to_s + ".jpg"
    # server_image_path = 'https://cnh-1.asaken1021.net:8080/progress_images/' + args.user_id.to_s + '_' + args.project_id.to_s + '.jpg'

    x_size = 600
    y_size = 120
    image = Magick::Image.new(x_size, y_size)
    idraw = Magick::Draw.new
    x_draw_size = x_size / 100 * args.project_progress

    idraw.fill('black')
    idraw.text(0, 13, 'Progress: ' + args.project_progress.to_i.to_s + '%')

    idraw.fill('lightgreen')
    idraw.stroke('gray')
    idraw.stroke_width(1)
    idraw.polygon(0, 20, 0, 120, x_draw_size, 120, x_draw_size, 20)

    idraw.draw(image)
    image.write(local_image_path)

    img_upload = Cloudinary::Uploader.upload(local_image_path)
    cloudinary_img_url = img_upload['url'].to_s.gsub('http', 'https')
    p cloudinary_img_url

    data = {
      message: '今日は ' + args.project_name + ' の ' + args.phase_name + ', 「' + args.task_name + '」の開発をしましょう。 https://cnh-1.asaken1021.net:8080/projects/' + args.project_id.to_s,
      to: args.line_id
    }.to_json

    data_image = {
      originalUrl: cloudinary_img_url,
      previewUrl: cloudinary_img_url,
      to: args.line_id
    }.to_json

    https = Net::HTTP.new(BotURI.host, BotURI.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(BotURI)
    req.body = data
    req['Content-Type'] = "application/json"
    req['Accept'] = "application/json"
    res = https.request(req)

    https = Net::HTTP.new(BotImageURI.host, BotImageURI.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(BotImageURI)
    req.body = data_image
    req['Content-Type'] = "application/json"
    req['Accept'] = "application/json"
    res = https.request(req)
  end
end
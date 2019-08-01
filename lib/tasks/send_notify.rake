namespace :send_notify do
  desc "Notification Send Task"
  namespace :sunday do
    task :send_6to8 do
      User.all.each do |user|
        notify_days = Notify_Day.find_by(user_id: user.id)
        notify_times = Notify_Time.find_by(user_id: user.id)
        if notify_days.is_sunday
          if notify_times.notify_6to8
            puts '^q^'
          end
        end
      end
    end
  end
end
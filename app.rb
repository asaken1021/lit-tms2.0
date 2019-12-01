require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require 'sinatra/activerecord'
require './models'

require 'webrick/https'
require 'openssl'
require 'socket'

require 'open-uri'
require 'net/http'
require 'json'
require 'securerandom'

if Socket.gethostname == 'tms2.0.local'
  ssl_options = {
    SSLEnable: true,
    SSLCertificate: OpenSSL::X509::Certificate.new(File.open('/home/lit_users/workspace/cert.pem').read),
    SSLPrivateKey: OpenSSL::PKey::RSA.new(File.open('/home/lit_users/workspace/privkey.pem').read)
  }
  set :server_settings, ssl_options
end

enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user])
  end
end

get '/' do
  erb :index
end

get '/help' do
  erb :help
end

post '/sign_up' do #ユーザー作成
  @user = User.create(
    mail: params[:mail],
    name: params[:name],
    password: params[:password],
    password_confirmation: params[:password_confirmation],
    user_line_id: ""
  )
  if @user.persisted?
    session[:user] = @user.id
  end
  redirect to(params[:redirect_to])
end

post '/sign_in' do #ユーザーサインイン
  user = User.find_by(mail: params[:mail])
  if user && user.authenticate(params[:password])
    session[:user] = user.id
  end
  redirect to(params[:redirect_to])
end

post '/sign_out' do #ユーザーサインアウト
  session[:user] = nil
  redirect to(params[:redirect_to])
end

get '/users/:id' do #ユーザーページ
  @user = User.find_by(id: params[:id])
  @user_projects = Project.where(user_id: params[:id])
  @user_activities = UserActivity.where(user_id: params[:id]).order(:created_at).reverse_order
  if @user == nil
    @error_code = 3
    erb :error
  else
    erb :user_page
  end
end

get '/user_settings' do #ユーザー設定ページ
  if current_user == nil
    @error_code = 1
    erb :error
  else
    @user_days = UserDay.where(user_id: current_user.id)
    @user_times = UserTime.where(user_id: current_user.id)
    # @user_daysや@user_timesがnilの時の処理はerbで
    erb :user_settings
  end
end

get '/line_bot' do
  erb :line_bot
end

post '/set_user_line_id' do #ユーザーのLINEユーザーIDの設定
  if current_user == nil
    @error_code = 1
    erb :error
  else
    current_user.user_line_id = params[:line_id]
    current_user.save(:validate => false)
    redirect to(params[:redirect_to])
  end
end

post '/set_user_line_notify' do #ユーザーのLINE通知の曜日と時間設定
  if current_user == nil
    @error_code = 1
    erb :error
  else
    user_days = UserDay.where(user_id: current_user.id)
    user_times = UserTime.where(user_id: current_user.id)

    if user_days != nil # そのユーザーがすでに曜日の設定を保存していた場合
      user_days.each do |day|
        day.destroy # 全て削除する
      end
    end

    if user_times != nil # そのユーザーがすでに時間の設定を保存していた場合
      user_times.each do |time|
        time.destroy # 全て削除する
      end
    end

    if params[:notify_sun] != nil
      UserDay.create(user_id: current_user.id, day_id: 0)
    end
    if params[:notify_mon] != nil
      UserDay.create(user_id: current_user.id, day_id: 1)
    end
    if params[:notify_tue] != nil
      UserDay.create(user_id: current_user.id, day_id: 2)
    end
    if params[:notify_wed] != nil
      UserDay.create(user_id: current_user.id, day_id: 3)
    end
    if params[:notify_thu] != nil
      UserDay.create(user_id: current_user.id, day_id: 4)
    end
    if params[:notify_fri] != nil
      UserDay.create(user_id: current_user.id, day_id: 5)
    end
    if params[:notify_sat] != nil
      UserDay.create(user_id: current_user.id, day_id: 6)
    end

    if params[:notify_6to8] != nil
      UserTime.create(user_id: current_user.id, time_id: 0)
    end
    if params[:notify_8to10] != nil
      UserTime.create(user_id: current_user.id, time_id: 1)
    end
    if params[:notify_10to12] != nil
      UserTime.create(user_id: current_user.id, time_id: 2)
    end
    if params[:notify_12to14] != nil
      UserTime.create(user_id: current_user.id, time_id: 3)
    end
    if params[:notify_14to16] != nil
      UserTime.create(user_id: current_user.id, time_id: 4)
    end
    if params[:notify_16to18] != nil
      UserTime.create(user_id: current_user.id, time_id: 5)
    end
    if params[:notify_18to20] != nil
      UserTime.create(user_id: current_user.id, time_id: 6)
    end
    if params[:notify_20to22] != nil
      UserTime.create(user_id: current_user.id, time_id: 7)
    end
    if params[:notify_22to24] != nil
      UserTime.create(user_id: current_user.id, time_id: 8)
    end
    redirect to(params[:redirect_to])
  end
end

post '/set_user_groups' do #ユーザーの所属グループの設定
  if current_user == nil
    @error_code = 1
    erb :error
  else
    group_names = params[:group_names]
    group_names = group_names.split(" ")
    group_names.each do |group_name|
      group = Group.find_by(name: group_name)
      if group != nil
        UsersGroup.create(
          user_id: current_user.id,
          group_id: group.id
        )
     else
      #何もしない
     end
  end
  redirect to(params[:redirect_to])
  end
end

get '/create_group' do #グループ作成ページ
  erb :create_group
end

post '/create_group' do #グループ作成
  if current_user == nil
    @error_code = 1
    erb :error
  else
    group = Group.create(
      name: params[:name],
      description: params[:description]
    )
    # redirect to('/groups/' + group.id.to_s)
    redirect '/user_settings'
  end
end

get '/groups' do #グループ一覧（所属しているもののみ）
  if current_user == nil
    @error_code = 1
    erb :error
  else
    @groups = UsersGroup.where(user_id: current_user.id)
    erb :groups
  end
end

get '/groups/:id' do #グループページ
  if current_user == nil
    @error_code = 1
    erb :error
  else
    @group = Group.find_by(id: params[:id])
    @group_users = UsersGroup.where(group_id: params[:id])
    @group_users_id = []
    @group_users.each do |group_user|
      @group_users_id.push(group_user.user_id)
    end
    @group_activities = UserActivity.where(user_id: @group_users_id).order(:created_at).reverse_order
    is_valid_user = false
    @group_users.each do |group_user|
      if group_user.user_id == current_user.id
        is_valid_user = true
        break
      end
    end
    if (is_valid_user)
      erb :group_page
    else
      @error_code = 3
      erb :error
    end
  end
end

post '/create_project' do #プロジェクト作成
  if current_user == nil
    @error_code = 1
    erb :error
  else
    project = Project.create(
      name: params[:project_name],
      progress: 0,
      user_id: current_user.id
    )
    redirect '/projects'
  end
end

get '/projects' do #プロジェクト一覧
  if current_user == nil
    @projects = Project.where(user_id: 0) #NoMethodError対策
    erb :projects
  else
    @projects = Project.where(user_id: current_user.id)
    erb :projects
  end
end

get '/projects/:id' do #プロジェクトページ
  @project = Project.find(params[:id])
  @phases = Phase.where(project_id: @project.id)
  all_tasks = Task.where(project_id: @project.id)
  update_project_progress(params[:id])
  @status = check_user_project(@project.id)
  erb :project_page
end

post '/projects/:id/create_phase' do #フェーズ作成
  project = Project.find(params[:id])
  @error_code = check_user_project(project.id)
  if @error_code == 0
    deadline_date = params[:deadline_date].split('/')
    if deadline_date != nil
      if Date.valid_date?(deadline_date[0].to_i, deadline_date[1].to_i, deadline_date[2].to_i)
        Phase.create(
          name: params[:phase_name],
          deadline: Date.parse(params[:deadline_date]),
          project_id: project.id
        )
        redirect to('/projects/' + project.id.to_s)
      else
        redirect to('/projects/' + project.id.to_s)
      end
    else
      redirect to('/projects/' + project.id.to_s)
    end
  else
    erb :error
  end
end

get '/projects/:id/:phase_id' do #フェーズページ
  @project = Project.find(params[:id])
  @phases = Phase.where(project_id: @project.id)
  @selected_phase = Phase.find(params[:phase_id])
  @tasks = Task.where(project_id: @project.id).where(phase_id: @selected_phase.id)
  @tasks_count = @tasks.count
  @completed_tasks_count = @tasks.where(progress: 100).count
  if @completed_tasks_count == nil
    @completed_tasks_count = 0
  end
  update_project_progress(params[:id])
  @status = check_user_project(@project.id)
  erb :phase_page
end

post '/projects/:id/:phase_id/create_task' do #タスク作成
  project = Project.find(params[:id])
  @error_code = check_user_project(project.id)
  if @error_code == 0
    phase = Phase.find(params[:phase_id])
    Task.create(
      name: params[:task_name],
      memo: params[:task_memo],
      progress: 0,
      project_id: project.id,
      phase_id: phase.id
    )
    update_project_progress(params[:id])
    redirect to('/projects/' + project.id.to_s + '/' + phase.id.to_s)
  else
    erb :error
  end
end

post '/projects/:id/:phase_id/remove_task/:task_id' do #タスクの削除
  project = Project.find(params[:id])
  @error_code = check_user_project(project.id)
  if @error_code == 0
    phase = Phase.find(params[:phase_id])
    task = Task.find(params[:task_id])
    task.destroy
    update_project_progress(params[:id])
    redirect to('/projects/' + project.id.to_s + '/' + phase.id.to_s)
  else
    erb :error
  end
end

post '/projects/:id/:phase_id/edit_progress_task/:task_id' do #タスクの進捗度の編集
  project = Project.find(params[:id])
  @error_code = check_user_project(project.id)
  if @error_code == 0
    phase = Phase.find(params[:phase_id])
    task = Task.find(params[:task_id])
    task.progress = params[:progress]
    task.save
    update_project_progress(params[:id])
    if (params[:progress] == 100.to_s)
      post_user_activity("complete_task", params[:id], params[:phase_id], params[:task_id])
    else
      post_user_activity("update_task_progress", params[:id], params[:phase_id], params[:task_id])
    end
    redirect to('/projects/' + project.id.to_s + '/' + phase.id.to_s)
  else
    erb :error
  end
end

def update_project_progress(id = nil)
  project = Project.find(id)
  all_tasks = Task.where(project_id: project.id)
  completed_tasks = all_tasks.where(progress: 100)
  project.progress = calculate_progress(all_tasks.count, completed_tasks.count)
  project.save
end

def calculate_progress(all_tasks = nil, completed_tasks = nil)
  if all_tasks == 0
    return 0
  end
  return (completed_tasks.to_f / all_tasks.to_f * 100)
end

def check_user_project(project_id = nil)
  if current_user != nil
    if current_user.id == Project.find(project_id).user_id
      return 0
    else
      return 2
    end
  else
    return 1
  end
  return -1
end

 def post_user_activity(activity_type = nil, project_id = nil, phase_id = nil, task_id = nil)
  # activity_type は update_task_progress, complete_task, complete_phase, complete_project の必要がある
  UserActivity.create(
    user_id: current_user.id,
    project_id: project_id,
    phase_id: phase_id,
    task_id: task_id,
    activity: activity_type
  )
end

##### LINE アカウント連携 #####
get '/line_link' do
  @linkToken = params[:linkToken]
  erb :line_link
end

post '/line_link' do
  linkToken = params[:linkToken]
  user = User.find_by(mail: params[:mail])
  if user && user.authenticate(params[:password])
    nonce = SecureRandom.hex(64)
    Nonce.create(
      nonce: nonce,
      user_id: user.id
    )
    redirect to('https://access.line.me/dialog/bot/accountLink?linkToken=' + linkToken + '&nonce=' + nonce)
  end
end

post '/line_link_completed' do
  request.body.rewind
  params = JSON.parse(request.body.string)
  user = User.find_by(id: Nonce.find_by(nonce: params['nonce']))
  user.user_line_id = params['userId']
  user.save(:validate => false)
end
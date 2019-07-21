require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require 'sinatra/activerecord'
require './models'

require 'webrick/https'
require 'openssl'
require 'socket'

require 'line/bot'

if Socket.gethostname == 'sinatra-tms2.0.local'
  ssl_options = {
    SSLEnable: true,
    SSLCertificate: OpenSSL::X509::Certificate.new(File.open('/var/SSLCert/cert.pem').read),
    SSLPrivateKey: OpenSSL::PKey::RSA.new(File.open('/var/SSLCert/privkey.pem').read),
    SSLVerifyClient: OpenSSL::SSL::VERIFY_NONE
  }
  set :server_settings, ssl_options
end

enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user])
  end
end

def line_client
  @client ||= Line::Bot::Client.new{
    config.channel_secret = ENV['LINE_CHANNEL_SECRET']
    config.channel_token = ENV['LINE_CHANNEL_TOKEN']
  }
end

get '/' do
  erb :index
end

post '/sign_up' do #ユーザー作成
  @user = User.create(
    mail: params[:mail],
    name: params[:name],
    password: params[:password],
    password_confirmation: params[:password_confirmation]
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

get '/create_project' do #プロジェクト作成ページ
  erb :create_project
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
    if current_user.id == project_id
      return 0
    else
      return 2
    end
  else
    return 1
  end
  return -1
end

##### LINE Bot #####
post '/send_line_push' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end


end

post '/line_bot' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  events.each do | event |
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        message = {
          type: 'text',
          text: event.message['text']
        }
        client.reply_message(event['replyToken'], message)
      end
    end
  end

  'OK'
end
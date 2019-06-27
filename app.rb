require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require 'sinatra/activerecord'
require './models'

get '/' do
  erb :index
end

get '/create_project' do #プロジェクト作成ページ
  erb :create_project
end

post '/create_project' do #プロジェクト作成
  project = Project.create(
    name: params[:project_name],
    progress: 0
  )
  redirect '/projects'
end

get '/projects' do #プロジェクト一覧
  @projects = Project.all
  erb :projects
end

get '/projects/:id' do #プロジェクトページ
  @project = Project.find(params[:id])
  @phases = Phase.where(project_id: @project.id)
  all_tasks = Task.where(project_id: @project.id)
  update_project_progress(params[:id])
  erb :project_page
end

get '/projects/:id/create_phase' do #フェーズ作成ページ
  @project = Project.find(params[:id])
  erb :create_phase
end

post '/projects/:id/create_phase' do #フェーズ作成
  project = Project.find(params[:id])
  deadline_date = params[:deadline_date].split('-')
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
  erb :phase_page
end

get '/projects/:id/:phase_id/create_task' do #タスク作成ページ
  @project = Project.find(params[:id])
  @selected_phase = Phase.find(params[:phase_id])
  erb :create_task
end

post '/projects/:id/:phase_id/create_task' do #タスク作成
  project = Project.find(params[:id])
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
end

post '/projects/:id/:phase_id/remove_task/:task_id' do #タスクの削除
  project = Project.find(params[:id])
  phase = Phase.find(params[:phase_id])
  task = Task.find(params[:task_id])
  task.destroy
  update_project_progress(params[:id])
  redirect to('/projects/' + project.id.to_s + '/' + phase.id.to_s)
end

get '/projects/:id/:phase_id/edit_progress_task/:task_id' do #タスクの進捗度の編集ページ
  @project = Project.find(params[:id])
  @selected_phase = Phase.find(params[:phase_id])
  @task = Task.find(params[:task_id])
  erb :edit_progress_task
end

post '/projects/:id/:phase_id/edit_progress_task/:task_id' do #タスクの進捗度の編集
  project = Project.find(params[:id])
  phase = Phase.find(params[:phase_id])
  task = Task.find(params[:task_id])
  task.progress = params[:progress]
  task.save
  update_project_progress(params[:id])
  redirect to('/projects/' + project.id.to_s + '/' + phase.id.to_s)
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
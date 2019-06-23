require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require 'sinatra/activerecord'
require './models'

get '/' do
  erb :index
end

get '/create' do #プロジェクト作成ページ
  erb :create_project
end

post '/create' do #プロジェクト作成
  project = Project.create(
    name = params[:project_name],
    progress = 0
  )
  redirect '/projects'
end

get '/projects' do #プロジェクト一覧
  @projects = Project.all
  erb :projects
end
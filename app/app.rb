ENV["RACK_ENV"] ||= "development"

require 'sinatra/base'
require_relative 'data_mapper_setup'

class Chitter < Sinatra::Base
  enable :sessions
  set :session_secret, 'super secret'

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end

  get '/' do
    @messages = Message.all
    erb :'homepage'
  end

  post '/new' do
    message = Message.new(message: params[:message])
    message.save
    redirect to '/'
  end

  get '/users/new' do
    erb :'users/new'
  end

  post '/users' do
  user = User.create(name: params[:name],
              username: params[:username],
              email: params[:email],
              password: params[:password])
  session[:user_id] = user.id
  redirect to('/')
end

  run! if app_file == $0
end
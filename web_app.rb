require 'sinatra'

class WebApp < Sinatra::Base
  enable :sessions

  get '/' do
    "hello world"
  end

  get '/bye' do
    "goodbye"
  end

  get '/hello/:name' do
    "hello #{params[:name]}"
  end

  get '/hi' do
    "hi #{params[:qsname]}"
  end

  post '/goodnight' do
    "post goodnight #{params[:name]}"
  end

  put '/goodnight' do
    "put goodnight #{params[:name]}"
  end

  post '/showenv' do
    "env[test] #{env[:test]}"
  end

  post '/showsession' do
    "session[test] #{session[:test]}"
  end

end

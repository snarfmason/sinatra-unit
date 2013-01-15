require 'sinatra'

class WebParent < Sinatra::Base

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

end

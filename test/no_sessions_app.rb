require 'sinatra'

class NoSessionsApp < Sinatra::Base

  get '/showsession' do
    "session[test] #{session[:test]}"
  end

  post '/setsession' do
    session[:test] = params[:test]
  end

end

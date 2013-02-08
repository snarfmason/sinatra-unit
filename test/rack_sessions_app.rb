require 'sinatra'
require 'rack/session/cookie'
class RackSessionsApp < Sinatra::Base
  use Rack::Session::Cookie, :key => 'rack.session',
    :domain => 'exmaple.com',
    :path => '/',
    :expire_after => 2592000, # In seconds
    :secret => 'change_me'

  get '/showsession' do
    "session[test] #{session[:test]}"
  end

  post '/setsession' do
    session[:test] = params[:test]
  end

end

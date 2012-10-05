require 'web_parent'

class WebApp < WebParent
  enable :sessions

  post '/showenv' do
    "env[test] #{env[:test]}"
  end

  post '/showsession' do
    "session[test] #{session[:test]}"
  end

end

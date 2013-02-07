require 'web_parent'

class WebApp < WebParent
  enable :sessions

  post '/showenv' do
    "env[test] #{env[:test]}"
  end

  get '/showsession' do
    "session[test] #{session[:test]}"
  end

  get '/showobject' do
    @object = OpenStruct.new :foo => 1, :bar => 2, :baz => 3
    "foo=#{@object.foo}&bar=#{@object.bar}&baz=#{@object.baz}"
  end

end

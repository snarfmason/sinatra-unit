require 'rack_sessions_app'
require 'sinatra/unit'

require 'test/unit'

class TestRackSessionsApp < Test::Unit::TestCase
  def setup
    @app = RackSessionsApp.new
  end

  def test_session_show
    @app.session = { :test => 'hello' }
    response_body = @app.test_get '/showsession'
    assert_equal 'session[test] hello', response_body
  end

  def test_session_set
    assert_nil @app.session[:test]
    @app.test_post '/setsession', :test => 'goodbye'
    assert_equal 'goodbye', @app.session[:test]
  end
end

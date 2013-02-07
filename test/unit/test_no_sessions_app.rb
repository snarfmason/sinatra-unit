require 'no_sessions_app'
require 'sinatra/unit'

require 'test/unit'

class TestNoSessionsApp < Test::Unit::TestCase
  def setup
    @app = NoSessionsApp.new
  end

  def test_session_show
    assert_raises Sinatra::Unit::SessionsDisabledError do
      @app.session = { :test => 'hello' }
      response = @app.test_get '/showsession'
      assert_equal 'session[test] hello', response
    end
  end

  def test_session_set
    assert_raises Sinatra::Unit::SessionsDisabledError do
      assert_nil @app.session[:test]
      @app.test_post '/setsession', :test => 'goodbye'
      assert_equal 'goodbye', @app.session[:test]
    end
  end
end

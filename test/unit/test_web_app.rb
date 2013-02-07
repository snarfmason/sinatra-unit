require 'web_app'
require 'sinatra/unit'

require 'test/unit'

class TestWebApp < Test::Unit::TestCase
  def setup
    @app = WebApp.new
  end

  def test_returns_hello_world_on_index
    response = @app.test_request(:get, '/')
    assert_equal "hello world", response
  end

  def test_returns_goodbye_on_bye
    response = @app.test_request(:get, '/bye')
    assert_equal "goodbye", response
  end

  def test_has_hello_name
    response = @app.test_request(:get, '/hello/jon')
    assert_equal "hello jon", response
  end

  def test_returns_for_hi_with_param
    response = @app.test_request(:get, '/hi', :qsname => 'jon')
    assert_equal "hi jon", response
  end

  def test_work_with_get_wrapped_method
    response = @app.test_get '/'
    assert_equal "hello world", response
  end

  def test_raises_an_exception_for_unknown_route
    assert_raise Sinatra::Unit::UnknownRouteError do
      @app.test_get '/wrongroute'
    end

    begin
      @app.test_get '/wrongroute', :wrong_param => 'foobar'
    rescue => e
      assert_equal 'GET', e.method
      assert_equal '/wrongroute', e.path
      assert_equal 'foobar', e.params[:wrong_param]
      assert_match %r{GET.*/wrongroute}, e.message
    end
  end

  def test_works_with_post_data
    response = @app.test_post '/goodnight', :name => 'jon'
    assert_equal 'post goodnight jon', response
  end

  def test_works_with_pu
    response = @app.test_put '/goodnight', :name => 'jon'
    assert_equal 'put goodnight jon', response
  end

  def test_works_with_env
    @app.env = { :test => 'hello' }
    response = @app.test_post '/showenv'
    assert_equal 'env[test] hello', response
  end

  def test_session_show
    @app.session = { :test => 'hello' }
    response = @app.test_get '/showsession'
    assert_equal 'session[test] hello', response
  end

  def test_session_set
    assert_nil @app.session[:test]
    @app.test_post '/setsession', :test => 'goodbye'
    assert_equal 'goodbye', @app.session[:test]
  end

  def test_instance_variable_retrieval
    response = @app.test_get '/showobject'
    assert_equal 'foo=1&bar=2&baz=3', response
    assert_equal 1, @app.variables("object").foo
  end

  def test_only_retrieve_instance_variables_set_in_the_block
    response = @app.test_get '/showobject'
    assert_nil @app.variables("template_cache")
  end

  def test_do_not_retrieve_protected_instance_variables
    response = @app.test_get '/showobject'
    assert_nil @app.variables("__protected_ivars")
  end
end

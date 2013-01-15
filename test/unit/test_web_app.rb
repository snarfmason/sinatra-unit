require 'web_app'
require 'sinatra/unit'

require 'minitest/autorun'

class TestWebApp < MiniTest::Unit::TestCase
  def setup
    @app = WebApp.new
  end

  def test_returns_hello_world_on_index
    response = @app.test_request(:get, '/')
    assert_equal response, "hello world"
  end

  def test_returns_goodbye_on_bye
    response = @app.test_request(:get, '/bye')
    assert_equal response, "goodbye"
  end

  def test_has_hello_name
    response = @app.test_request(:get, '/hello/jon')
    assert_equal response, "hello jon"
  end

  def test_returns_for_hi_with_param
    response = @app.test_request(:get, '/hi', :qsname => 'jon')
    assert_equal response, "hi jon"
  end

  def test_work_with_get_wrapped_method
    response = @app.test_get '/'
    assert_equal response, "hello world"
  end

  def test_return_nil_for_wrong_route
    response = @app.test_get '/wrongroute'
    assert_nil response
  end

  def test_works_with_post_data
    response = @app.test_post '/goodnight', :name => 'jon'
    assert_equal response, 'post goodnight jon'
  end

  def test_works_with_pu
    response = @app.test_put '/goodnight', :name => 'jon'
    assert_equal response, 'put goodnight jon'
  end

  def test_works_with_env
    @app.env = { :test => 'hello' }
    response = @app.test_post '/showenv'
    assert_equal response, 'env[test] hello'
  end

  def test_works_with_session
    @app.session = { :test => 'hello' }
    response = @app.test_post '/showsession'
    assert_equal response, 'session[test] hello'
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

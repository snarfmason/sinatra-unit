# sinatra-unit

* http://github.com/snarfmason/sinatra-unit

Testing harness for Sinatra to make proper unit tests/specs for actions.

Description
-----------

The idea is to instantiate your Sintra class and then execute the web request blocks on the instance
that you have created. It uses the `test_request` method (and shortcuts like `test_get`, `test_put`, etc)
to look up the block using the same route matching logic that Sinatra would use when receiving a request
from Rack.

Usage
-----

Basic usage:

    @app = WebApp.new
    response_body = @app.test_request(:get, '/')

of course you can do, params:

    response_body = @app.test_request(:get, '/hi', :qsname => 'jon')

you can set the environment or session (if enabled) with a hash, before a request

    @app.env = { :test => 'hello' }
    @app.session = { :test => 'hello' }
    response_body = @app.test_get '/showsession'

Currently the text of the response is returned from the `test_request` method. If you need access to headers or HTTP status you use the `response` object.

    @app.response.status
    @app.response.header['Content-Type']


Writing Tests
-------------

basic good route:

    response_body = @app.test_request(:get, '/')
    assert_equal "hello world", response_body
    assert_equal 200, @app.response.status
    assert_equal 'text/html', @app.response.header['Content-Type']

basic bad route:

    assert_raise Sinatra::Unit::UnknownRouteError do
      @app.test_get '/wrongroute'
    end

basic redirect:

    @app.test_get '/redirect'
    assert @app.redirect?
    assert_equal 302, @app.response.status

you can retrieve instance variables set in request blocks

    # app
    get '/showobject' do
      @object = OpenStruct.new :foo => 1, :bar => 2, :baz => 3
      "foo=#{@object.foo}&bar=#{@object.bar}&baz=#{@object.baz}"
    end

    # test
    response_body = @app.test_get '/showobject'
    assert_equal 'foo=1&bar=2&baz=3', response_body
    assert_equal 1, @app.variables("object").foo

you can assert against session values

    # app
    post '/setsession' do
      session[:test] = params[:test]
    end
    
    # test
    assert_nil @app.session[:test]
    @app.test_post '/setsession', :test => 'goodbye'
    assert_equal 'goodbye', @app.session[:test]

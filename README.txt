# sinatra-unit

* http://github.com/snarfmason/sinatra-unit

Testing harness for Sinatra to make proper unit tests/specs for actions.

Description
-----------

The idea is to instantiate your Sintra class and then execute the web request blocks on the instance
that you have created. It uses the `test_request` method (and shortcuts like `test_get`, `test_put`, etc)
to look up the block using the same route matching logic that Sinatra would use when receiving a request
from Rack.

This is a really early piece of work right now, and isn't even a gem yet. It's just a class I include in
`spec_helper.rb`.

Usage
-----

Best thing to do right now is just read `web_app_spec.rb` for usage examples, but the general idea is:

    app = WebApp.new
    response = app.test_get '/hi'
    response.should == "hello world"

of course you can do, params:

    response = app.test_get '/hi' :name => 'Jon'

you can set the environment or session (if enabled) with a hash, before a request

    app.env = { :test => 'hello' }
    app.session = { :test => 'hello' }
    response = app.test_get '/hi'

you can retrieve instance variables set in request blocks

    app.variables("object").foo.should == 1

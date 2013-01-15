require 'spec_helper'
require 'web_app'
require 'sinatra_unit'

describe 'my app' do
  let(:app) { WebApp.new }

  it "should return hello world for /" do
    response = app.test_request(:get, '/')
    response.should == "hello world"
  end

  it "should return goodbye for /bye" do
    response = app.test_request(:get, '/bye')
    response.should == "goodbye"
  end

  it "should return for /hello/:name" do
    response = app.test_request(:get, '/hello/jon')
    response.should == "hello jon"
  end

  it "should return for /hi with a param" do
    response = app.test_request(:get, '/hi', :qsname => 'jon')
    response.should == "hi jon"
  end

  it "should work with get wrapped method" do
    response = app.test_get '/'
    response.should == "hello world"
  end

  it "should return nil for wrong route" do
    response = app.test_get '/wrongroute'
    response.should be_nil
  end

  it "should work with post data" do
    response = app.test_post '/goodnight', :name => 'jon'
    response.should == 'post goodnight jon'
  end

  it "should work with put" do
    response = app.test_put '/goodnight', :name => 'jon'
    response.should == 'put goodnight jon'
  end

  it "should work with env" do
    app.env = { :test => 'hello' }
    response = app.test_post '/showenv'
    response.should == 'env[test] hello'
  end

  it "should work with session" do
    app.session = { :test => 'hello' }
    response = app.test_post '/showsession'
    response.should == 'session[test] hello'
  end

  it "should be able to retrieve an instance variable" do
    response = app.test_get '/showobject'
    response.should == 'foo=1&bar=2&baz=3'
    app.variables("object").foo.should == 1
  end

  it "should not be able to retrieve instance variables not set in the block" do
    response = app.test_get '/showobject'
    app.variables("template_cache").should be_nil
  end

  it "should not be able to retrieve the protected instance variables list" do
    response = app.test_get '/showobject'
    app.variables("__protected_ivars").should be_nil
  end

end

require 'spec_helper'
require 'web_app'
require 'sinatra_unit'

describe 'my app' do
  it "should return hello world for /" do
    app = WebApp.new
    response = app.test_request(:get, '/')
    response.should == "hello world"
  end

  it "should return goodbye for /bye" do
    app = WebApp.new
    response = app.test_request(:get, '/bye')
    response.should == "goodbye"
  end

  it "should return for /hello/:name" do
    app = WebApp.new
    response = app.test_request(:get, '/hello/jon')
    response.should == "hello jon"
  end

  it "should return for /hi with a param" do
    app = WebApp.new
    response = app.test_request(:get, '/hi', :qsname => 'jon')
    response.should == "hi jon"
  end

  it "should work with get wrapped method" do
    app = WebApp.new
    response = app.test_get '/'
    response.should == "hello world"
  end

  it "should return nil for wrong route" do
    app = WebApp.new
    response = app.test_get '/wrongroute'
    response.should be_nil
  end

  it "should work with post data" do
    app = WebApp.new
    response = app.test_post '/goodnight', :name => 'jon'
    response.should == 'post goodnight jon'
  end

  it "should work with put" do
    app = WebApp.new
    response = app.test_put '/goodnight', :name => 'jon'
    response.should == 'put goodnight jon'
  end

  it "should work with env" do
    app = WebApp.new
    app.env = { :test => 'hello' }
    response = app.test_post '/showenv'
    response.should == 'env[test] hello'
  end

  it "should work with session" do
    app = WebApp.new
    app.session = { :test => 'hello' }
    response = app.test_post '/showsession'
    response.should == 'session[test] hello'
  end

end

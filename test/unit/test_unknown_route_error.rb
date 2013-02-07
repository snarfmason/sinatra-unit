require 'web_app'
require 'sinatra/unit'
require 'test/unit'

class TestUnknownRouteError < Test::Unit::TestCase
  def test_unknown_route_exception_details
    error = nil
    begin
      WebApp.new.test_get '/wrongroute', :wrong_param => 'foobar'
    rescue => e
      error = e
    end

    assert_not_nil error
    assert_equal 'GET', error.method
    assert_equal '/wrongroute', error.path
    assert_equal 'foobar', error.params[:wrong_param]
    assert_match %r{GET.*/wrongroute.*wrong_param.*foobar}, error.message
  end
end


require 'ostruct'

module Sinatra
  class Unit
    VERSION = '0.1.0'

    class UnknownRouteError < StandardError
      attr_accessor :method, :path, :params
      def initialize(method, path, params)
        self.method, self.path, self.params = method, path, params
        message = "Could not resovle route #{method} #{path} with params #{params.inspect}"
        super message
      end
    end
  end

  class Base
    def setup_test_session
      @request = OpenStruct.new :session => {} if request.nil?
    end

    # normal session method just returns request.session
    def session
      setup_test_session
      request.session
    end

    # also there is no paired session=, unlike env which is an attr
    def session=(session_hash)
      setup_test_session
      @request.session = session_hash
    end

    # test_request comes mostly from the guts of route! in Sinatra::Base
    def test_request(method, path, params={})
      @params = indifferent_params(params)

      @request ||= OpenStruct.new
      @request.route = path # sinatra 1.2.8
      @request.path_info = path # sinatra 1.3.3

      @__protected_ivars = instance_variables + ["@__protected_ivars"]

      # routes are stored by uppercase method, but I wanted the test interface
      # to accept :get or 'get' as well as 'GET'
      test_request_internal self.class, method.to_s.upcase
    end

    def variables(name)
      name = "@#{name.to_s}"
      instance_variable_get(name) unless @__protected_ivars.include?(name)
    end

    # expects @request and @params to be set
    # Don't call this directly, but I don't believe in private methods
    def test_request_internal(route_holder, method)
      raise Sinatra::Unit::UnknownRouteError.new(method,@request.path_info,@params) unless route_holder.respond_to?(:routes)

      if route_holder.routes.has_key? method
        routes = route_holder.routes[method]
        routes.each do |pattern, keys, conditions, block|
          process_route(pattern, keys, conditions) do |*args|
            return block[*args]
          end
        end
      end

      test_request_internal(route_holder.superclass, method)
    end

    %w(get post put delete head).each do |method|
      eval <<-CODE
        def test_#{method}(path, params={})
          test_request('#{method}', path, params)
        end
      CODE
    end

    # Sinatra makes new do a bunch of stuff with rack middleware wrappers
    # that are useful if you're actually running the app, but provides
    # new! for regular instantiation. I'm just re-standardizing names
    class << self
      alias new_with_rack_wrappers new
      alias new new!
    end

  end
end

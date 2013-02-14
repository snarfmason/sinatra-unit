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

    class SessionsDisabledError < StandardError ; end
  end

  class Base
    def test_sessions_enabled?
      return true if self.class.sessions?

      used_middleware = self.class.instance_variable_get "@middleware"
      used_middleware.each do |middleware|
        return true if middleware.first == Rack::Session::Cookie
      end

      return false
    end

    # Normal sinatra session method just returns request.session which passes
    # through to env['rack.session'] but I don't initialize the request object
    # until just before the route lookkup, so I need to skip directly to env.
    def session
      raise Sinatra::Unit::SessionsDisabledError unless test_sessions_enabled?
      env['rack.session'] ||= {}
    end

    # This doesn't exist in regular sinatra, but it's convenient for some tests
    def session=(session)
      raise Sinatra::Unit::SessionsDisabledError unless test_sessions_enabled?
      env['rack.session'] = session
    end

    # test_request comes mostly from the guts of route! in Sinatra::Base
    def test_request(method, path, params={})
      @params = indifferent_params(params)

      @request = Sinatra::Request.new(env)
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
    end

    def self.new
      app = new!
      app.env ||= {}
      app
    end

  end
end

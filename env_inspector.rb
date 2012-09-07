require 'pp'

class EnvInspector
  def initialize(app)
    @app = app
  end

  def call(env)
    puts "\n\n--------\nenv:"
    pp env.collect { |k,v| [k,v] }.sort
    puts "========"
    @app.call(env)
  end
end

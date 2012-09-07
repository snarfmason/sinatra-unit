require 'rubygems'
require 'bundler'
Bundler.setup

require 'web_app'
require 'env_inspector'

use EnvInspector 

run WebApp

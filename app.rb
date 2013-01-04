# encoding: utf-8
require 'sinatra'
require 'haml'
require 'yaml'
require 'RedCloth'
require 'date'
require 'gravatar'
require 'twitter'
require 'rdiscount'

config_file =  File.exists?('config.yml') ? 'config.yml' : 'config.example.yml'

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
  require_relative 'helpers.rb'
end

%w(lib models).each do |req| 
  Dir["#{req}/*.rb"].each { |f| require_relative f }
end

CACHE = {}
CONFIG = YAML.load_file('app.settings.yml').symbolize_keys
SETTINGS = YAML.load_file(config_file).symbolize_keys

enable :sessions

configure :production do
  set :haml, { :ugly=>true }
  set :clean_trace, true
end

if twitter_enabled
  Twitter.configure do |config|
    config.consumer_key = SETTINGS[:twitter][:consumer_key]
    config.consumer_secret = SETTINGS[:twitter][:consumer_secret]
    config.oauth_token = SETTINGS[:twitter][:access_token]
    config.oauth_token_secret = SETTINGS[:twitter][:access_token_secret]
  end
end

require_relative 'routes.rb'
CACHE[:articles] = skim_articles

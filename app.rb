# encoding: utf-8
require 'sinatra'
require 'haml'
require 'yaml'
require 'RedCloth'
require 'date'
require 'titleize'
require 'gravatar'
require 'twitter'
require 'levenshtein'


helpers do
  include Rack::Utils
  alias_method :h, :escape_html
  require_relative 'helpers.rb'
end

%w(lib models).each do |req| 
  Dir["#{req}/*.rb"].each { |f| require_relative f }
end

CACHE = {}
SETTINGS = YAML.load_file('config.yml').symbolize_keys

enable :sessions

configure :production do
  set :haml, { :ugly=>true }
  set :clean_trace, true
  # set :css_files, :blob
  # set :js_files,  :blob
  # MinifyResources.minify_all
end

configure :development do
  # set :css_files, MinifyResources::CSS_FILES
  # set :js_files,  MinifyResources::JS_FILES
end

if twitter_enabled
  p "Twitter is enabled"
  Twitter.configure do |config|
    config.consumer_key = SETTINGS[:twitter][:consumer_key]
    config.consumer_secret = SETTINGS[:twitter][:consumer_secret]
    config.oauth_token = SETTINGS[:twitter][:access_token]
    config.oauth_token_secret = SETTINGS[:twitter][:access_token_secret]
  end
end

require_relative 'routes.rb'


# frozen_string_literal: true

require 'bundler/setup'
require 'sinatra'

$:.unshift File.expand_path('lib', __dir__)
require 'sql-to-ruby'

class SQLToRuby::App < Sinatra::Base
  APP_DIR = File.expand_path('app', __dir__)

  get '/' do
    send_file(File.join(APP_DIR, 'index.html'))
  end

  get '/convert' do
    SQLToRuby.convert(params['sql'])
  end
end

run SQLToRuby::App

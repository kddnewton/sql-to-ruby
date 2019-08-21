# frozen_string_literal: true

require 'bundler/setup'
require 'sinatra'

$:.unshift File.expand_path('lib', __dir__)
require 'sql-to-ruby'

class SQLToRuby::App < Sinatra::Base
  get '/' do
    send_file(File.expand_path('index.html', __dir__))
  end

  get '/convert' do
    SQLToRuby.convert(params['sql'])
  end
end

run SQLToRuby::App

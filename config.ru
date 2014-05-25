require 'sinatra'
require './app.rb'

run App

$stdout.sync = true
config.logger = Logger.new(STDOUT)

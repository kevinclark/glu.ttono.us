require 'rubygems'
require 'sinatra'

get '/' do
  body File.read(File.join(File.dirname(__FILE__), 'public/index.html'))
end

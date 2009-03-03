require 'rubygems'
require 'sinatra'
require 'rdiscount'
require 'coderay'
require 'scanf'

# Static stuff
get '/' do
  erb :index
end

get '/oldsite' do
  body File.read(File.join(File.dirname(__FILE__), 'public/index.html'))
end


# Code
EXT_TO_CODERAY = {
  "rb" => :ruby
}

$code = []

Dir[File.join(File.dirname(__FILE__), "code", "*")].each do |file|
  name, ext = File.basename(file).scan(/(\w+)\.(\w+)/)[0]
  tokens = CodeRay.scan(File.read(file), EXT_TO_CODERAY[ext])
  $code << [File.basename(file), tokens.div(:line_numbers => :inline, :css => :class)]
  
  get "/code/#{File.basename(file)}" do
    send_file file
  end
end

before do
  @code = $code.last # [filename, html]
end


# Read
$articles = {}
$links = []

Dir[File.join(File.dirname(__FILE__), "articles", "*.markdown")].each do |file|
  name = File.basename(file, ".markdown")
  $links << name
  
  get "/articles/#{name}" do
    $articles[name] ||= Markdown.new(File.read(file)).to_html
    @read = $articles[name]
    erb :index
  end
end
  
  
  
  
  
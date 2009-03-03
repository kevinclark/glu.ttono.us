# This is all of the 'blog' part of the site, sans templates
# http://github.com/kevinclark/glu.ttono.us/
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
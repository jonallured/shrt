require 'dotenv'
require 'erb'
require 'haml'
require 'yaml'

desc 'Deploy site'
task deploy: :build do
  Dotenv.load
  system "rsync -av -e ssh --delete build/ #{ENV['DEPLOY_TARGET']}"
end

desc 'Build the site'
task :build do
  class Namespace
    def links
      YAML.load File.read 'data/links.yml'
    end

    def get_binding; binding end
  end

  binding = Namespace.new.get_binding

  Dir.mkdir 'build'

  renderer = ERB.new(File.read('source/.htaccess.erb'), nil, '<>')
  File.write 'build/.htaccess', renderer.result(binding)

  engine = Haml::Engine.new(File.read('source/index.haml'))
  File.write 'build/index.html', engine.render(binding)
end

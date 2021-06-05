require 'dotenv'
require 'erb'
require 'haml'
require 'yaml'

Rake.add_rakelib 'lib/tasks'

desc 'Deploy site'
task deploy: :build do
  Dotenv.load
  command = "rsync -av -e ssh --delete build/ #{ENV['DEPLOY_TARGET']}"
  system(command, exception: true)
end

desc 'Build the site'
task :build do
  class Namespace
    def links
      YAML.load File.read 'data/links.yml'
    end

    def posts
      YAML.load File.read 'data/posts.yml'
    end

    def get_binding; binding end
  end

  binding = Namespace.new.get_binding

  Dir.mkdir 'build' unless File.directory? 'build'

  renderer = ERB.new(File.read('source/.htaccess.erb'), nil, '<>')
  File.write 'build/.htaccess', renderer.result(binding)

  engine = Haml::Engine.new(File.read('source/index.haml'))
  File.write 'build/index.html', engine.render(binding)
end

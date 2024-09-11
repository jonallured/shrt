require "dotenv"
require "erb"
require "haml"
require "yaml"
require "standard/rake"

Rake.add_rakelib "lib/tasks"

class Namespace
  def links
    YAML.safe_load_file("data/links.yml")
  end

  def posts
    YAML.safe_load_file("data/posts.yml")
  end

  def get_binding
    binding
  end
end

desc "Deploy site"
task deploy: :build do
  Dotenv.load
  command = "rsync -av -e ssh --delete build/ #{ENV["DEPLOY_TARGET"]}"
  system(command, exception: true)
end

desc "Build the site"
task :build do
  namespace = Namespace.new
  binding = namespace.get_binding

  Dir.mkdir "build" unless File.directory? "build"

  renderer = ERB.new(File.read("source/.htaccess.erb"), trim_mode: "<>")
  File.write "build/.htaccess", renderer.result(binding)

  engine = Haml::Template.new { File.read("source/index.haml") }
  File.write "build/index.html", engine.render(namespace)
end

task default: %i[standard build]

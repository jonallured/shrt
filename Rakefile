require "dotenv"
require "erb"
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
  Dir.mkdir "build" unless File.directory? "build"

  namespace = Namespace.new
  binding = namespace.get_binding
  template_paths = %w[source/.htaccess.erb source/index.html.erb]

  template_paths.each do |template_path|
    output_path = template_path.gsub("source", "build").gsub(".erb", "")
    template_data = File.read(template_path)
    renderer = ERB.new(template_data, trim_mode: "<>")
    output_data = renderer.result(binding)
    File.write(output_path, output_data)
  end
end

task default: %i[standard build]

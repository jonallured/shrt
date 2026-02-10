require "dotenv"
require "erb"
require "yaml"
require "standard/rake"

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
  FileUtils.rm_rf("build")
  FileUtils.mkdir("build")

  namespace = Namespace.new
  binding = namespace.get_binding
  source_paths = Dir.children("source").map { |child| "source/#{child}" }

  source_paths.each do |source_path|
    output_path = source_path.gsub("source", "build")

    unless source_path.end_with?(".erb")
      FileUtils.cp(source_path, output_path)
      next
    end

    output_path = output_path.gsub(".erb", "")
    template_data = File.read(source_path)
    renderer = ERB.new(template_data, trim_mode: "<>")
    output_data = renderer.result(binding)
    File.write(output_path, output_data)
  end
end

task default: %i[standard build]

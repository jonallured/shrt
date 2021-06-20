require "./lib/post_redirect"

desc "Generate blog post redirects"
task :generate_posts do
  paths = Dir.glob("../jonallured.com/source/posts/*.md")
  redirects = paths.map { |path| PostRedirect.for(path) }
  data = redirects.sort.map(&:to_hash).to_yaml
  File.write("data/posts.yml", data)
end

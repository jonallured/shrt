require 'dotenv'
Dotenv.load

desc "Deploy site"
task :deploy do
  system "middleman build --clean"
  system "mv build/htaccess.html build/.htaccess"
  system "rsync -av -e ssh --delete build/ #{ENV['DEPLOY_TARGET']}"
end

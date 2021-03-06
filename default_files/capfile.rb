# Setup here
repo   = `git ls-remote --get-url`.split(':')[1].gsub(/\.git$/, '').gsub(/[\\\n]/, '')
branch = `git rev-parse --symbolic-full-name --abbrev-ref HEAD`.gsub(/[\\\n]/, '')
cmd    = "runurl https://raw.githubusercontent.com/levelupify/devops/master/bin/deploy"
common = "#{cmd} #{repo} #{branch}"

# role :web_servers, "oleherland.no"
role :web_servers, "web1.levelup.no", "web2.levelup.no"

set :user, "levelup"

desc "Deploy Levelup Web Site to production"
task :deploy, :roles => :web_servers do
  run "#{common} prod update quiet"
end

desc "Deploy Levelup Web Site to staging"
task :stage, :roles => :web_servers do
  run "#{common} staging update quiet"
end

desc "Deploy Levelup Web Site to development"
task :dev, :roles => :web_servers do
  run "#{common} dev update quiet"
end

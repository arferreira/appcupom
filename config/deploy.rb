require 'bundler/capistrano'

set :domain, 'www.trazcupom.com'
set :application, "appcupom"

set :keep_releases, 3

set :scm, :git

ssh_options[:forward_agent] = true

default_run_options[:pty] = true

set :repository, 'git@github.com:arferreira/appcupom.git'
set :rails_env, "production"
set :branch, 'master'

set :user, "root"
set :use_sudo, false

set :deploy_to, '/var/www/cupom'


role :web, domain
role :app, domain
role :db,  domain, primary: true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

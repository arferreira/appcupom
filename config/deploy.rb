require 'bundler/capistrano'

set :default_environment, {
  :PATH => '/opt/local/bin:/opt/local/sbin:/opt/local/ruby/gems/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  :GEM_HOME => '/opt/local/ruby/gems'
}

set :application, '198.199.102.159'

set :keep_releases, 3

set :scm, :git

ssh_options[:forward_agent] = true

default_run_options[:pty] = true

set :repository, 'git@github.com:arferreira/appcupom.git'

set :branch, 'master'

set :deploy_via, :copy

set :user, "root"

set :use_sudo, false

set :deploy_to, '/var/www/cupom'

set :current, "#{deploy_to}/current"

role :web, application
role :app, application
role :db,  application, primary: true


namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end


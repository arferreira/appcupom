require 'bundler/capistrano'
require 'capistrano-unicorn'

set :default_environment, {
  :PATH => '/opt/local/bin:/opt/local/sbin:/opt/local/ruby/gems/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  :GEM_HOME => '/opt/local/ruby/gems'
}

set :application, 'www.trazcupom.com'

set :keep_releases, 3

set :scm, :git

set :repository, 'git@github.com:arferreira/appcupom.git'

set :branch, 'master'

set :deploy_via, :remote_cache

set :user, "root"

set :use_sudo, false

set :deploy_to, '/var/www/cupom'

set :current, "#{deploy_to}/current"

role :web, application
role :app, application
role :db,  application, primary: true


namespace :deploy do
  after 'deploy:restart', 'unicorn:reload' # app IS NOT preloaded
  after 'deploy:restart', 'unicorn:restart'  # app preloaded
end


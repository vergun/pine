require 'bundler/setup'
require 'rvm/capistrano'
require 'bundler/capistrano'

set :application, "pine"
set :repository, "git@github.com:vergun/pine.git"
set :rvm_ruby_string, "system"
set :rvm_type, :user
set :branch, "master"
set :timestamp, Time.now.strftime("%Y-%m-%d_%H-%M")
set :node_env, "production"
set :deploy_to, "~/ebs_volume/"
set :user, 'vergun'
set :scm_verbose, true
set :scm, :git
set :use_sudo, false
set :ssh_options, { forward_agent: true }
set :keep_releases, 5

server "pine.sugarcrm.com", :web, :app, :primary => true

before "deploy:setup", "rvm:install_rvm"
before "deploy:setup", "rvm:install_ruby"
after "deploy:update_code", "deploy:symlink"
after "deploy:symlink", "deploy:init_submodule"
after "deploy:submodule", "deploy:install_node_modules"
after "deploy:node_modules", "deploy:restart_pm2"

namespace :deploy do 
  
  desc "Symlink files and directories"
  task :symlink do
    run <<-EOS
      ln -s #{release_path} ~/ebs_volume/current &&
      ln -s ~/ebs_volume/shared/node_modules #{release_path}/node_modules &&
      ln -s ~/ebs_volume/shared/log ~/ebs_volume/releases/#{release_path}/log &&
      ln -s ~/ebs_volume/shared/config/application.yml ~/ebs_volume/releases/#{release_path}/config/application.yml &&
      ln -s ~/ebs_volume/shared/config/database.yml ~/ebs_volume/releases/#{release_path}/config/database.yml
    EOS
  end

  desc "Initialize submodule"
  task :init_submodule do
    run <<-EOS
      git submodule add ~/ebs_volume/shared/submodules/Pine_Needles
      git submodule init
      git submodule update
    EOS
  end
  
  desc "Install node dependencies"
  task :install_node_modules do
    run "cd #{release_path}; npm install --production"
  end
  
  desc "Restart pm2"
  task :restart_pm2 do
  end
  
end

namespace :maintenacne do
  
  desc "Reset submodule"
  task :reset_submodules do
  end
end

namespace :pm2 do
  desc "Start"
  task :start do
  end
  
  desc "Stop"
  task :stop do
  end
  
  desc "Restart"
  task :restart do
  end
end

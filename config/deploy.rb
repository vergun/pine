require 'bundler/setup'
require 'rvm/capistrano'
require 'bundler/capistrano'

set :application, "pine"
set :repository, "git@github.com:vergun/pine.git"
set :branch, "master"
set :timestamp, Time.now.strftime("%Y-%m-%d_%H-%M")
set :deploy_to, "~/ebs_volume/"
set :user, 'vergun'

set :rvm_type, :user
set :rvm_ruby_string, "ruby-1.9.3-p484@pine"
set :node_env, "production"

set :scm_verbose, true
set :scm, :git
set :use_sudo, false
set :ssh_options, { forward_agent: true }
set :keep_releases, 5
set :normalize_asset_timestamps, false

server "pine-shell.sugarcrm.com", :web, :app, :primary => true

before "deploy:setup",                  "rvm:install_rvm"
before "deploy:setup",                  "rvm:install_ruby"

after "deploy:update_code",             "deploy:symlink_configs"
after "deploy:symlink_configs",         "deploy:init_submodule"

after "deploy:init_submodule",          "npm:install"
after "npm:install",                    "pm2:restart"

namespace :deploy do 
  
  desc "Symlink files and directories"
  task :symlink_configs do
    %w(application.yml database.yml).each do |f|
      shared = "#{shared_path}/config/#{f}"
      release = "#{release_path}/config/#{f}"
      run <<-EOS
        if [ -f #{shared} ] ; then
          if [ -f #{release} ] ; then
            rm #{release};
          fi;
          ln -s #{shared} #{release};
        fi
      EOS
    end   
    run "ln -s #{shared_path}/node_modules #{release_path}/node_modules"
  end

  desc "Initialize submodule"
  task :init_submodule do
    submodule = "#{release_path}/Pine_Needles"
    run <<-EOS
      if [ -f #{submodule} ] ; then
        rm -rf #{submodule};
      fi;
      ln -s #{release_path} #{shared_path}/submodules/Pine_Needles
    EOS
  end
  
end

namespace :npm do
  
  desc "Install node modules"
  task :install do
    run "cd #{release_path}; npm install --production"
  end
  
end

namespace :pm2 do
  
  desc "Start"
  task :start do
    name = "#{application}"
    run "pm2 start --name #{name} -o ~/ebs_volume/shared/logs/production.log -e ~/ebs_volume/shared/logs/error.log"
  end
  
  desc "Stop"
  task :stop do
    name = "#{application}"
    run "pm2 stop #{name}"
    run "pm2 delete all"
  end
  
  desc "Restart"
  task :restart do
    run "cd ~/ebs_volume && ./restart_server"
  end
  
end

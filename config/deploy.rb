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
set :normalize_asset_timestamps, false


server "pine.sugarcrm.com", :web, :app, :primary => true

before "deploy:setup",                  "rvm:install_rvm"
before "deploy:setup",                  "rvm:install_ruby"

after "deploy:update_code",             "deploy:symlink_configs"
after "deploy:symlink_configs",         "deploy:init_submodule"
after "deploy:init_submodule",          "deploy:install_node_modules"
after "deploy:install_node_modules",    "deploy:restart_pm2"

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
    run "ln -s #{shared_path}/submodules/Pine_Needles #{release_path}/Pine_Needles"
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

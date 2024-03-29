# frozen_string_literal: true

require "mina/rails"
require "mina/git"
require "mina/rbenv" # for rbenv support. (https://rbenv.org)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :application_name, "zesty"
set :domain, ENV["host"] || fail("provide a host please")
set :deploy_to, "/srv/www/zesty"
set :repository, "git@github.com:jlebensold/zesty.git"
set :branch, ENV["branch"] || "master"

set :rbenv_path, "/home/zesty/.rbenv"

# Optional settings:
set :user, "zesty" # Username in the server to SSH to.
set :port, "22" # SSH port number.
set :forward_agent, true # SSH forward_agent.

# shared dirs and files will be symlinked into the app-folder by the
# 'deploy:link_shared_paths' step.
set :shared_dirs, fetch(:shared_dirs, []).push("assets")
set :term_mode, nil
# set :shared_files, fetch(:shared_files, []).push(config/database.yml', 'config/secrets.yml')

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  invoke :'rbenv:load'
  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use', 'ruby-1.9.3-p125@default'
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  command %(mkdir -p #{File.join(fetch(:deploy_to), 'shared', 'assets')})
  command %(echo "Don't forget to setup the production environment variables")
end

desc "Deploys the current version to the server."
task :deploy_web do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %(mkdir -p tmp/)
        command %(mkdir -p tmp/pids)
        command %(sudo systemctl restart puma)
      end
    end
  end
end

task :deploy_worker do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'deploy:cleanup'
    on :launch do
      in_path(fetch(:current_path)) do
        command %(mkdir -p tmp/)
        command %(mkdir -p tmp/pids)
        command %(sudo systemctl restart sidekiq)
      end
    end
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs

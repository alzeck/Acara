# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"

set :application, "Acara"
set :repo_url, "https://github.com/AlZeck/Acara.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/monty/#{fetch :application}"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/master.key"

namespace :deploy do
    namespace :check do
      before :linked_files, :set_master_key do
        on roles(:app), in: :sequence, wait: 10 do
          unless test("[ -f #{shared_path}/config/master.key ]")
            upload! 'config/master.key', "#{shared_path}/config/master.key"
          end
        end
      end
    end
  end

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'

# Default value for default_env is {}
set :default_env, { 
  FACEBOOK_APP_ID: ENV['FACEBOOK_APP_ID'],
  FACEBOOK_APP_SECRET: ENV['FACEBOOK_APP_SECRET'],
  SENDGRID_API_KEY: ENV['SENDGRID_API_KEY'],
  SENDGRID_USERNAME: ENV['SENDGRID_USERNAME'],
  SENDGRID_PASSWORD: ENV['SENDGRID_PASSWORD'],
  HERE_API_KEY: ENV['HERE_API_KEY'],
  DATABASE_URL: ENV['DATABASE_URL']
}

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

set :passenger_in_gemfile, true
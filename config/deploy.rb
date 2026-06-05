lock "~> 3.20"

set :application, "odinbook"
set :repo_url, "git@github.com:hungnguyen1607/odinbook.git"
set :branch, :main
set :deploy_to, "/var/www/odinbook"
set :pty, true
set :linked_files, %w[config/master.key config/database.yml]
set :linked_dirs, %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system]
set :keep_releases, 5
set :rbenv_ruby, "3.3.8"
set :puma_threads, [4, 16]
set :puma_workers, 2
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log, "#{release_path}/log/puma.error.log"
set :puma_preload_app, true


namespace :deploy do
  before "deploy:assets:precompile", :build_tailwind do
    on roles(:web) do
      within release_path do
        execute :bundle, "exec rails tailwindcss:build"
      end
    end
  end
end

namespace :deploy do
  after :finished, :restart_puma do
    on roles(:web) do
      within release_path do
        execute :pkill, "-f puma", raise_on_non_zero_exit: false
        execute "RAILS_ENV=production nohup bundle exec puma -C #{release_path}/config/puma.rb &"
      end
    end
  end
end
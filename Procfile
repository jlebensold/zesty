web: PORT=3000 bin/rails s
redis: redis-server config/redis.conf
sidekiq: bin/sidekiq -L log/sidekiq.log -P tmp/pids/sidekiq.pid, -q default

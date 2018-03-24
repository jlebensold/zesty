web: bin/rails s -p 3000 -b 0.0.0.0
redis: redis-server config/redis.conf
sidekiq: bin/sidekiq -L log/sidekiq.log -P tmp/pids/sidekiq.pid, -q default

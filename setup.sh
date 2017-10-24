#!/bin/sh
export RAILS_ENV=staging
bundle exec pumactl -S /home/yatteiki/rails/kakei_gakuen/shared/tmp/pids/puma.state stop
git pull origin develop
bundle install --without test development
bundle exec rails db:migrate RAILS_ENV=production
bundle exec rails assets:precompile RAILS_ENV=production
export SECRET_KEY_BASE=bundle exec rake secret
export RAILS_ENV=staging
bundle exec puma -t 5:5 -e production -C config/puma.rb -d
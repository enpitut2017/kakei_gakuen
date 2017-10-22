su -l yatteiki_deploy -c 'cd /var/www/yatteiki && export RAILS_ENV=production && bundle exec pumactl -S /var/www/yatteiki/shared/tmp/pids/puma.state stop'
sudo rm -rf /var/www/yatteiki/*
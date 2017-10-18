su -l yatteiki_deploy -c 'cd /var/www/yatteiki && bundle exec pumactl -S /var/www/yatteiki/shared/tmp/pids/puma.state stop'
sudo rm -rf /var/www/yatteiki
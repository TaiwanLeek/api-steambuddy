web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
fetch_worker: bundle exec shoryuken -r ./workers/fetch_player_worker.rb -C ./workers/fetch_player/shoryuken.yml
update_worker: bundle exec shoryuken -r ./workers/update_player_worker.rb -C ./workers/update_player/shoryuken.yml
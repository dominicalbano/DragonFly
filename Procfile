web: bundle exec rails server -p $PORT -e $RACK_ENV
web: bundle exec redis-server
worker: bundle exec rake environment resque:work QUEUE=CMS
worker: bundle exec rake environment resque:work QUEUE=CLW
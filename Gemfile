source 'https://rubygems.org'

##rails
gem 'rails', '3.2.13'

##Database
gem 'mysql2'

##External Integration
#twitter
gem 'oauth'
gem 'twitter'

#facebook
gem 'oauth2'
gem "koala"

##Javascript
gem 'jquery-rails'
gem 'json'

#Image upload
gem 'paperclip'

#Searching
gem 'sunspot_rails'
gem 'progress_bar' # for sunspot:solr:reindex

group :assets do
  gem 'sass-rails'
  gem 'compass-rails'
  gem 'coffee-rails'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier'
end


group :development do
  gem "capistrano"
  gem 'capistrano-unicorn', :require => false
  gem 'sunspot_solr', :git => "https://github.com/mrcsparker/sunspot.git"
end

#Dev and test only
#group :development, :test do
  #bundle exec annotate
  #gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
#end

gem 'multi_json', '1.3.6'
gem 'unicorn'
#Decorator Design Pattern
gem 'draper'

gem 'nokogiri'

gem 'httparty'

gem 'uglifier'

gem 'execjs'

gem 'will_paginate'
# gem 'best_in_place'

# gem 'therubyracer'

gem 'font_assets'

#Detect Browser
gem 'browser'
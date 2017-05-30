source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'activeadmin', github: 'activeadmin'
gem 'active_admin_theme'
gem 'activeadmin-select2', github: 'mfairburn/activeadmin-select2'
gem "active_admin_import" , '3.0.0'
gem 'bootstrap-toggle-rails'
gem 'bootstrap-sass', '~> 3.1.1'
gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'exception_notification'
gem 'font-awesome-rails'
gem 'geocoder'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'mina'
gem 'mysql2'
gem 'photofy'
gem 'pnotify-rails'
gem 'puma', '~> 3.0'
gem 'rails', '~> 5.0.3'
gem 'sass-rails', '~> 5.0'
gem 'select2-rails'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'uglifier', '>= 1.3.0'
gem 'unobtrusive_flash', '>=3'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'letter_opener'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end
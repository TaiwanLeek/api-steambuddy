# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

## Configuration and Utilities
gem 'figaro', '~> 1.2'
gem 'rack-test' # for testing and can also be used to diagnose in production
gem 'rake', '~> 13.0'

# Presentation Layer
gem 'multi_json', '~> 1.15'
gem 'roar', '~> 1.1'

## Web Application
gem 'puma', '~> 6'
gem 'rack-session', '~> 0.3'
gem 'roda', '~> 3'

## Networking
gem 'httparty'

## Database
gem 'hirb', '~> 0'
gem 'sequel', '~> 5.49'

# Controllers and services
gem 'dry-monads', '~> 1.4'
gem 'dry-transaction', '~> 0.13'
gem 'dry-validation', '~> 1.7'

# DOMAIN LAYER
# Validation
gem 'dry-struct', '~> 1'
gem 'dry-types', '~> 1'

# INFRASTRUCTURE LAYER
# Networking
gem 'http', '~> 5'

group :development, :test do
  gem 'sqlite3', '~> 1.4'
end

group :test do
  gem 'minitest', '~> 5'
  gem 'minitest-rg', '~> 5'

  gem 'simplecov', '~> 0'
  gem 'vcr', '~> 6.0'
  gem 'webmock', '~> 3.0'
end

group :development do
  gem 'rerun', '~> 0'
end

# Debugging
gem 'pry'

# Quaility
group :development do
  gem 'flog'
  gem 'reek'
  gem 'rubocop', '~> 1.40'
end

# Database
group :production do
  gem 'pg'
end

gem 'debug', '~> 1.7'

# Asynchronicity
gem 'aws-sdk-sqs', '~> 1.48'
gem 'concurrent-ruby', '~> 1.1'
gem 'shoryuken', '~> 5.3'

gem 'benchmark', '~> 0.2.1'

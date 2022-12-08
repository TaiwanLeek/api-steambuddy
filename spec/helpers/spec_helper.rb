# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
# TODO: Adding this cause problems
# require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../../require_app'
require_app
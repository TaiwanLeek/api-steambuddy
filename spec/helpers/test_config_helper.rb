# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'yaml'

CONFIG = YAML.safe_load(File.read('config/secrets.yml'))['test']
STEAM_KEY = CONFIG['steam_key']
STEAM_ID = CONFIG['steam_id_0']

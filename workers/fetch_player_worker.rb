# frozen_string_literal: true

require_relative '../require_app'
require_app

require 'figaro'
require 'shoryuken'
require 'json'

# Shoryuken worker class to fetch player info in parallel
class FetchPlayerWorker
  # Environment variables setup
  Figaro.application = Figaro::Application.new(
    environment: ENV['RACK_ENV'] || 'development',
    path: File.expand_path('config/secrets.yml')
  )
  Figaro.load
  def self.config = Figaro.env

  Shoryuken.sqs_client = Aws::SQS::Client.new(
    access_key_id: config.AWS_ACCESS_KEY_ID,
    secret_access_key: config.AWS_SECRET_ACCESS_KEY,
    region: config.AWS_REGION
  )

  include Shoryuken::Worker
  shoryuken_options queue: config.FETCH_QUEUE_URL, auto_delete: true

  def perform(_sqs_msg, request)
    new_player = SteamBuddy::Steam::PlayerMapper
                 .new(SteamBuddy::App.config.STEAM_KEY)
                 .find(JSON.parse(request))

    db_player = SteamBuddy::Repository::For.entity(new_player).find_or_create_with_friends(new_player)
    SteamBuddy::Repository::Players.rebuild_entity_with_friends(db_player)
  rescue StandardError => e
    puts 'Perform error!'
    puts e.to_s
    puts 'Perform error end!'
  end
end

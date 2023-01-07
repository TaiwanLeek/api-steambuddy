# frozen_string_literal: true

require_relative '../require_app'
require_app

require 'figaro'
require 'shoryuken'
require 'json'

# Shoryuken worker class to fetch player info in parallel
class UpdatePlayerWorker
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
  shoryuken_options queue: config.UPDATE_QUEUE_URL, auto_delete: true

  def perform(_sqs_msg, request)
    Repository::Players.all.each { |player| notify_clone_workers(player.remote_id) }
  rescue StandardError => e
    puts 'Perform error!'
    puts e.to_s
    puts 'Perform error end!'
  end

  def notify_clone_workers(input)
    # queues = [App.config.FETCH_QUEUE_URL, App.config.REPORT_QUEUE_URL]
    queues = [App.config.UPDATE_QUEUE_URL]

    queues.each do |queue_url|
      Concurrent::Promise.execute do
        Messaging::Queue
          .new(queue_url, App.config)
          .send(input.to_json)
      end
    end
  end
end


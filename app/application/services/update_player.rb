# frozen_string_literal: true

require 'dry/transaction'

module SteamBuddy
  module Service
    # Update players information that already in database
    class UpdatePlayer
      include Dry::Transaction

      step :notify_clone_workers

      private

      def notify_clone_workers()
        # queues = [App.config.FETCH_QUEUE_URL, App.config.REPORT_QUEUE_URL]
        queues = [App.config.UPDATE_QUEUE_URL]
        message = "update db"
        queues.each do |queue_url|
          Concurrent::Promise.execute do
            Messaging::Queue
              .new(queue_url, App.config)
              .send(message)
          end
        end
      end

      # Messaging::Queue
      #  .new(App.config.FETCH_QUEUE_URL, App.config)
      #  .send(input[:remote_id].to_json)
    end
  end
end

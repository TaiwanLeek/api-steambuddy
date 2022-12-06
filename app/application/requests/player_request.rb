# frozen_string_literal: true

module SteamBuddy
  module Request
    class PlayerRemoteId
      def initialize(remote_id)
        @remote_id = remote_id
      end

      attr_reader :remote_id
    end
  end
end

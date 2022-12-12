# frozen_string_literal: true

require 'dry/monads'

module SteamBuddy
  module Service
    # Retrieves array of all listed player entities
    class ListPlayers
      include Dry::Transaction

      step :retrieve_all_players

      def retrieve_all_players
        Repository::For.klass(Entity::Player).all
                       .then { |players| Response::PlayersList.new(players) }
                       .then { |list| Response::ApiResult.new(status: :ok, message: list) }
                       .then { |result| Success(result) }
      rescue StandardError
        Failure(
          Response::ApiResult.new(status: :internal_error, message: DB_ERR)
        )
      end
    end
  end
end

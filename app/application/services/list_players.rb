# frozen_string_literal: true

require 'dry/monads'
require 'dry/transaction'

module SteamBuddy
  module Service
    # Retrieves array of all listed player entities
    class ListPlayers
      include Dry::Transaction

      step :validate_list
      step :retrieve_players

      private

      DB_ERR = 'Cannot access database'

      # Expects list of player info in input[:list_request]
      def validate_list(input)
        list_request = input[:list_request].call
        if list_request.success?
          Success(input.merge(list: list_request.value!))
        else
          Failure(list_request.failure)
        end
      end

      def retrieve_players(input)
        Repository::For.klass(Entity::Player).find_full_id(input[:list])
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

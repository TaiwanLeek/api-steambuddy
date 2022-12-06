# frozen_string_literal: true

require 'dry/transaction'

module SteamBuddy
  module Service
    # Transaction to store player from Steam API to database

    class AddPlayer
      include Dry::Transaction

      step :find_player
      step :store_player

      private

      DB_ERR_MSG = 'Having trouble accessing the database'

      def find_player(input)
        player = player_from_database(input)
        if player&.full_friend_data
          input[:local_player] = player
        else
          input[:remote_player] = player_from_steam(input)
        end
        Success(input)
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :not_found, message: e.to_s))
      end

      def store_player(input)
        player =
          if (new_player = input[:remote_player])
            db_player = Repository::For.entity(new_player).find_or_create_with_friends(new_player)
            Repository::Players.rebuild_entity_with_friends(db_player)
          else
            input[:local_player]
          end
        Success(Response::ApiResult.new(status: :created, message: player))
      rescue StandardError => e
        puts e.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR_MSG))
      end

      # Following are support methods that other services could use

      def player_from_steam(input)
        # Get player from API
        Steam::PlayerMapper
          .new(App.config.STEAM_KEY)
          .find(input[:remote_id])
      rescue StandardError
        raise 'Could not find that player on Steam'
      end

      def player_from_database(input)
        Repository::For.klass(Entity::Player).find_id(input[:db_player_id])
      end
    end
  end
end

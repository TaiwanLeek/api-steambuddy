# frozen_string_literal: false

module SteamBuddy
  module Repository
    # Repository class for player data accessing
    class Players
      @listed_games_number = 5

      def self.all
        Database::PlayerOrm.all.map { |db_player| rebuild_entity(db_player) }
      end

      def self.find_id(remote_id)
        rebuild_entity_with_friends(Database::PlayerOrm.find(remote_id:))
      end

      def self.rebuild_entity_with_friends(db_player)
        return unless db_player

        Entity::Player.new(
          db_player.to_hash.merge(
            played_games: rebuild_games_entity(db_player),
            friend_list: rebuild_friends_entity(db_player)
          )
        )
      end

      def self.rebuild_entity(db_player)
        return unless db_player

        Entity::Player.new(
          db_player.to_hash.merge(
            played_games: rebuild_games_entity(db_player),
            friend_list: nil
          )
        )
      end

      def self.rebuild_games_entity(db_player)
        db_player.owned_games&.map { |db_owned_game| OwnedGames.rebuild_entity(db_owned_game) }
      end

      def self.rebuild_friends_entity(db_player)
        db_player.friends&.map { |db_friend| rebuild_entity(db_friend) }
      end

      # Create records of one player and all of their friend
      def self.find_or_create_with_friends(entity)
        db_player = find_or_create(entity)

        entity&.friend_list&.each do |friend_entity|
          db_player_friend = find_or_create(friend_entity)

          unless db_player.friends_dataset.first(remote_id: friend_entity.remote_id)
            db_player.add_friend(db_player_friend)
          end
          unless db_player_friend.friends_dataset.first(remote_id: entity.remote_id)
            db_player_friend.add_friend(db_player)
          end
        end
      end

      # Create a record of player in database based on a player entity
      def self.find_or_create(entity)
        db_player = Database::PlayerOrm.find_or_create(entity.to_attr_hash)
        entity&.played_games&.sort do |played_game_a, played_game_b|
          played_game_b.played_time <=> played_game_a.played_time
        end&.first(@listed_games_number)&.each do |owned_game_entity|
          OwnedGames.create(db_player, owned_game_entity)
        end
        db_player
      end
    end
  end
end

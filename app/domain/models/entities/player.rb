# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

require_relative('owned_game')

module SteamBuddy
  module Entity
    # Domain entity for team members
    class Player < Dry::Struct
      include Dry.Types

      attribute :remote_id, Strict::String
      attribute :username, Strict::String
      attribute :game_count, Strict::Integer
      attribute :full_friend_data, Strict::Bool
      attribute :owned_games, Array.of(OwnedGame).optional
      attribute :friend_list, Array.of(Player).optional
      attribute :total_play_time, Strict::Integer.optional

      def to_attr_hash
        to_hash.except(:owned_games, :friend_list)
      end

      def favorite_game
        owned_games&.min { |owned_game_a, owned_game_b| owned_game_b.played_time <=> owned_game_a.played_time }
      end
    end
  end
end

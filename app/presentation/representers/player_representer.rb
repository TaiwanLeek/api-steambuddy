# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'game_representer'

module SteamBuddy
  module Representer
    class Player < Roar::Decorator
      include Roar::JSON

      property :remote_id
      property :username
      property :game_count
      property :full_friend_data
      property :total_play_time
      property :favorite_game, extend: Representer::OwnedGame, class: OpenStruct
      collection :owned_games, extend: Representer::OwnedGame, class: OpenStruct
      collection :friend_list, extend: Representer::Player, class: OpenStruct
    end
  end
end

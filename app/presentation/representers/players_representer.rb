# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'player_representer'

module SteamBuddy
  module Representer
    class PlayersList < Roar::Decorator
      include Roar::JSON

      collection  :players, extend: Representer::Player, class: OpenStruct
    end
  end
end

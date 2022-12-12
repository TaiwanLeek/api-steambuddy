# frozen_string_literal: true

require 'base64'
require 'dry/monads'
require 'json'

module SteamBuddy
  module Request
    class EncodedPlayersList
      include Dry::Monads::Result::Mixin

      def initialize(params)
        @params = params
      end

      def call
        Success(
          Json.parse(decode(@params['list']))
        )
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status: :bad_request,
            message: 'Player list not found'
          )
        )
      end

      def decode(param)
        Base64.urlsafe_decode64(param)
      end

      def self.to_encoded(list)
        Base64.urlsafe_encode64(list.to_json)
      end
    end
  end
end

# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

module SteamBuddy
  # Web App
  class App < Roda
    route do |routing|
      response['Content-Type'] = 'application/json'

      # GET /
      routing.root do
        message = "SteamBuddy API v1 at /api/v1/ in #{App.environment} mode"

        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message:)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'api' do
        routing.on 'v1' do
          routing.on 'players' do
            routing.on String do |_player_id|
              # GET /players/{player_id}/
              routing.get do
              end
            end
          end
        end
      end
    end
  end
end

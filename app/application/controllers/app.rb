# frozen_string_literal: true

require 'roda'

module SteamBuddy
  # Web App
  class App < Roda
    plugin :halt
    plugin :all_verbs

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
            routing.on String do |remote_id|
              # GET /players/{remote_id}/
              routing.get do
                'Under construction!'
              end

              # POST /players/{remote_id}
              routing.post do
                result = Service::AddPlayer.new.call(remote_id:)

                if result.failure?
                  failed = Representer::HttpResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                http_response = Representer::HttpResponse.new(result.value!)
                response.status = http_response.http_status_code
                Representer::Player.new(result.value!.message).to_json
              end
            end
          end
        end
      end
    end
  end
end

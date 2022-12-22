# frozen_string_literal: true

require_relative '../../helpers/test_config_helper'
require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'
require 'rack/test'

def app
  SteamBuddy::App
end

describe 'Test API routes' do
  include Rack::Test::Methods

  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_steam
    DatabaseHelper.wipe_database
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Root route' do
    it 'should successfully return root information' do
      get '/'
      _(last_response.status).must_equal 200

      body = JSON.parse(last_response.body)
      _(body['status']).must_equal 'ok'
      _(body['message']).must_include 'api/v1'
    end
  end

  describe 'Get STEAM ID64 players list' do
    it 'should be able to get player info' do
      SteamBuddy::Service::AddPlayer.new.call(remote_id: STEAM_ID)

      get "/api/v1/players/#{STEAM_ID}/"
      _(last_response.status).must_equal 201

      player = JSON.parse(last_response.body)
      _(player['remote_id']).must_equal STEAM_ID
      _(player['username']).must_equal USERNAME
      _(player['game_count']).must_equal 33
      _(player['full_friend_data']).must_equal true
    end

    it 'should be report error for an invalid player' do
      SteamBuddy::Service::AddPlayer.new.call(remote_id: 'wefsvsvva')

      # get "/api/v1/players/#{STEAM_ID}/"
      get '/api/v1/players/wefsvsvva/'
      _(last_response.status).must_equal 404
      _(JSON.parse(last_response.body)['status']).must_include 'not'
    end
  end

  describe 'Get base64_json_array players list' do
    it 'should successfully return lists of players info' do
      SteamBuddy::Service::AddPlayer.new.call(remote_id: STEAM_ID)

      list = ["#{STEAM_ID}"]
      encoded_list = SteamBuddy::Request::EncodedPlayersList.to_encoded(list)

      get "/api/v1/players?list=#{encoded_list}"
      _(last_response.status).must_equal 200

      response = JSON.parse(last_response.body)
      players = response['players']
      _(players.count).must_equal 1
      player = players.first
      _(player['remote_id']).must_equal STEAM_ID
      _(player['username']).must_equal USERNAME
      _(player['game_count']).must_equal 33
    end

    it 'should return empty lists if none found' do
      list = ['djsafildafs;d/239eidj-fdjs']
      encoded_list = SteamBuddy::Request::EncodedPlayersList.to_encoded(list)

      get "/api/v1/players?list=#{encoded_list}"
      _(last_response.status).must_equal 200

      response = JSON.parse(last_response.body)
      players = response['players']
      _(players).must_be_kind_of Array
      _(players.count).must_equal 0
    end

    it 'should return error if not list provided' do
      get '/api/v1/players'
      _(last_response.status).must_equal 400

      response = JSON.parse(last_response.body)
      _(response['message']).must_include 'list'
    end
  end
end

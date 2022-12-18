# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require 'rack/test'

def app
  SteamBuddy::App
end

describe 'Test API routes' do
  include Rack::Test::Methods

  describe 'Root route' do
    it 'should successfully return root information' do
      get '/'
      _(last_response.status).must_equal 200

      body = JSON.parse(last_response.body)
      _(body['status']).must_equal 'ok'
      _(body['message']).must_include 'api/v1'
    end
  end

  describe 'Get players list' do
    it 'should successfully return player lists' do
      SteamBuddy.Service.AddPlayer.new.call(remote_id: STEAMID)

      list = ["#{STEAMID}"]
      encoded_list = SteamBuddy::Request::EncodedPlayersList.to_encoded(list)

      get "/api/v1/players?list=#{encoded_list}"
      _(last_response.status).must_equal 200

      response = JSON.parse(last_response.body)
      players = response['players']
      _(players.count).must_equal 1
      player = players.first
      _(player['remote_id']).must_equal STEAMID
      _(player['username']).must_equal 'Cherise'
      _(player['game_count'].count).must_equal 33
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

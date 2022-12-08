# frozen_string_literal: true

require_relative '../../helpers/spec_helper'

def app
  SteamBuddy::App
end

describe 'Test API routes' do
  describe 'Root route' do
    it 'should just work' do
      _(true).must_equal true
    end
  end
end

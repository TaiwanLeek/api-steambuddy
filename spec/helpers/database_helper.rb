# frozen_string_literal: true

# Helper to clean database during test runs
module DatabaseHelper
  # Deliberately :reek:DuplicateMethodCall on App.DB
  def self.wipe_database
    # Ignore foreign key constraints when wiping tables
    SteamBuddy::App.DB.run('PRAGMA foreign_keys = OFF')
    SteamBuddy::Database::PlayerOrm.map(&:destroy)
    SteamBuddy::Database::OwnedGameOrm.map(&:destroy)
    SteamBuddy::Database::GameOrm.map(&:destroy)
    SteamBuddy::App.DB.run('PRAGMA foreign_keys = ON')
  end
end

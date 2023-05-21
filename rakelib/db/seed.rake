namespace :db do
  desc 'Seed the database with application required data'
  task seed: :settings do
    require 'sequel/core'

    Sequel.connect(Settings.db.to_hash) do |db|
      DB = db
      load 'db/seeds.rb'
    end
  end
end

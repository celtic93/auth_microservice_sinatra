namespace :db do
  desc 'Run database migrations'
  task :migrate, %i[version] => :settings do |t, args|
    require 'sequel/core'
    Sequel.extension :migration

    Sequel.connect(Settings.db.to_hash) do |db|
      migrations = File.expand_path('../../db/migrations', __dir__)
      version = args.version.to_i if args.version

      Sequel::Migrator.run(db, migrations, target: version)
      sh %(sequel -D postgresql://#{Settings.db.user}:#{Settings.db.password}@#{Settings.db.host}/#{Settings.db.database} > db/schema.rb) if ENV['RACK_ENV'] ||= 'development'
    end
  end
end

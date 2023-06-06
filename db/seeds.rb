require 'securerandom'

created_at = DateTime.now
updated_at = DateTime.now

puts 'Creating users...'
DB[:users].insert(
  name: 'John',
  email: 'john@test.com',
  password_digest: 'password',
  created_at: created_at,
  updated_at: updated_at,
)
DB[:users].insert(
  name: 'Mike',
  email: 'mike@test.com',
  password_digest: 'password',
  created_at: created_at,
  updated_at: updated_at,
)
puts "#{DB[:users].count} users created!"
puts 'Creating user sessions...'
users = DB[:users].all
DB[:user_sessions].insert(
  user_id: users.first[:id],
  uuid: SecureRandom.uuid,
  created_at: created_at,
  updated_at: updated_at,
)
DB[:user_sessions].insert(
  user_id: users.last[:id],
  uuid: SecureRandom.uuid,
  created_at: created_at,
  updated_at: updated_at,
)
puts "#{DB[:user_sessions].count} user sessions created!"

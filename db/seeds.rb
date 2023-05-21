puts 'Creating ads...'
DB[:ads].insert(
  title: 'Apple',
  description: 'Apple ad description',
  city: 'Moscow',
  user_id: 1,
  created_at: DateTime.now,
  updated_at: DateTime.now,
)
DB[:ads].insert(
  title: 'Samsung',
  description: 'Samsung ad description',
  city: 'London',
  user_id: 1,
  created_at: DateTime.now,
  updated_at: DateTime.now,
)
DB[:ads].insert(
  title: 'Dell',
  description: 'Dell ad description',
  city: 'Paris',
  user_id: 2,
  created_at: DateTime.now,
  updated_at: DateTime.now,
)
puts 'Adds created!'

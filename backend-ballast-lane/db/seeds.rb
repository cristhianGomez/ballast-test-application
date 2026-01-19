# Create a test user (development/test only)
if Rails.env.development? || Rails.env.test?
  User.find_or_create_by!(email: "test@example.com") do |user|
    user.password = "password123"
    user.password_confirmation = "password123"
  end
  puts "Test user created (development/test only)"
else
  puts "Skipping test user creation in #{Rails.env} environment"
end

puts "Seed data completed!"

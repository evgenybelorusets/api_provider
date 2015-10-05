p "Seeds started #{Time.now}"
p 'Seeding client application'

client_application = ClientApplication.create! email: 'test@example.com',
  password: 'password',
  password_confirmation: 'password'

p "Key: #{client_application.key} Secret: #{client_application.secret}"
p 'Seed users, posts and comments in client application'
p "Seeds ended #{Time.now}"
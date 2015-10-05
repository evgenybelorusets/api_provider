p "Seeds started #{Time.now}"

p 'Seeding client application'

client_application = ClientApplication.create! email: 'test@example.com',
  password: 'password',
  password_confirmation: 'password'

p "Key: #{client_application.key} Secret: #{client_application.secret}"
p 'Seed users, posts and comments in client application or uncomment code in db/seeds.rb.'
p 'Note though, that users will not be create in any client application database then.'

=begin
p 'Seeding users'

admin = User.create! first_name: 'Bruce',
  last_name: 'Wayne',
  email: 'b.wayne@example.com',
  client_application: client_application,
  role: 'admin',
  uid: 'brucewayne'

user1 = User.create! first_name: 'John',
  last_name: 'Snow',
  email: 'j.snow@example.com',
  client_application: client_application,
  role: 'user',
  uid: 'knowsnothing'

user2 = User.create! first_name: 'Vicious',
  last_name: 'Raccoon',
  email: 'v.raccoon@example.com',
  client_application: client_application,
  role: 'user',
  uid: 'cutenessoverload'

p 'Seeding posts'

post1 = Post.create! title: "I'm the darkness", content: some_text(5000), user: admin
post2 = Post.create! title: 'I know something', content: some_text(5000), user: user1
post3 = Post.create! title: "I'm cute", content: some_text(5000), user: user2

p 'Seeding Comments'

[ admin, user1, user2 ].each do |user|
  [ post1, post2, post3 ].each do |post|
    Comment.create! user: user, post: post, content: some_text(255)
  end
end
=end

p "Seeds ended #{Time.now}"
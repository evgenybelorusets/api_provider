p "Seeds started #{Time.now}"

TEXT = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum nibh felis, tempor ut condimentum ac, tempor et urna. Donec vel sem eu ligula euismod blandit. Donec laoreet ullamcorper orci, et tristique dolor sodales at. Interdum et malesuada fames ac ante ipsum primis in faucibus. Sed nec posuere nunc. Donec laoreet, libero id tristique fermentum, urna sapien ullamcorper quam, in iaculis lacus metus vel enim. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Quisque venenatis rutrum metus scelerisque venenatis. Sed tincidunt dignissim purus interdum dictum. Aliquam id mi ut enim feugiat malesuada. Aenean id orci nisi. Integer varius orci id volutpat porttitor. Praesent sodales lorem sed consectetur laoreet. Fusce neque libero, sodales ut pellentesque non, finibus eget metus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Aenean sit amet mauris et odio semper tristique a nec nulla.
Praesent at consequat risus. Morbi iaculis tincidunt velit non dignissim. Maecenas aliquet facilisis leo, non aliquam arcu aliquam vitae. Praesent eget nisi dapibus, bibendum justo sed, dignissim quam. Maecenas nibh massa, placerat id eros in, vehicula tincidunt velit. Mauris eget lorem nec urna rhoncus convallis. Sed luctus velit rhoncus, blandit orci sed, ullamcorper nibh. Aenean tempor condimentum tortor nec placerat. Vivamus augue tellus, ultrices euismod augue luctus, scelerisque tincidunt magna. Mauris quis mattis neque, ac dictum massa. In tristique justo augue, id hendrerit velit vehicula id. Phasellus vitae accumsan est. Maecenas quis scelerisque justo. Vivamus ultrices enim ut convallis vulputate. Vestibulum bibendum elit sed eros dictum, id tempor justo viverra.
Sed tellus justo, accumsan consequat purus faucibus, lacinia sodales tellus. Fusce et bibendum turpis. Etiam cursus vitae odio eget suscipit. Curabitur sit amet est et libero molestie condimentum et quis metus. In imperdiet placerat nulla, a condimentum turpis tincidunt in. Mauris id felis velit. Donec magna ligula, pellentesque eget lacus eget, rutrum blandit sapien. Donec sed accumsan lacus. Donec fringilla augue in quam semper, eu feugiat diam eleifend.
Maecenas a risus placerat, faucibus leo in, commodo metus. Ut vehicula nunc eget ipsum hendrerit, at tincidunt enim pellentesque. Curabitur scelerisque malesuada neque sit amet placerat. Pellentesque nec euismod magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas ipsum turpis, cursus sit amet nulla quis, mattis mollis urna. Curabitur lobortis sagittis ante vitae condimentum.
Pellentesque mauris lorem, vestibulum vel cursus eu, blandit in libero. Maecenas placerat nibh mauris, eget convallis sapien vehicula tristique. Maecenas sagittis commodo nulla, et volutpat sapien accumsan ac. Nulla porttitor quam aliquam, euismod odio suscipit, tristique purus. Nullam imperdiet laoreet erat, id fermentum enim feugiat quis. Vivamus semper varius massa vitae mollis. Ut sollicitudin, enim efficitur tempor interdum, tellus eros elementum lacus, et semper metus libero id sem. Phasellus vestibulum ligula eu augue dignissim, efficitur ullamcorper turpis ultricies. Vivamus rhoncus porttitor mauris ut suscipit. Sed in dui nulla. Vivamus scelerisque odio vitae magna dignissim dignissim. Morbi ut nunc eget lectus faucibus dictum eu ac tortor."

TEXT_LENGTH = TEXT.length

def some_text(max_value)
  start_position = rand(TEXT_LENGTH / 2)
  end_position = rand((start_position + 1)..(start_position + max_value))
  TEXT[start_position...end_position]
end

p 'Seeding client application'

client_application = ClientApplication.create! email: 'test@example.com',
  password: 'password',
  password_confirmation: 'password'

p "Key: #{client_application.key} Secret: #{client_application.secret}"

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

p "Seeds ended #{Time.now}"
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar")

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password)

end

users = User.order(:created_at).take(6)
50.times do
  title = Faker::Lorem.sentence(5)
  users.each { |user| user.blogs.create!(title: title) }
end

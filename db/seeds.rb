Faker::Config.locale = 'ja'

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

  users.each do |user|
    user.blogs.create!(title: title)
  end
end

50.times do
  entry_title = Faker::Lorem.sentence(2)
  entry_body = Faker::Lorem.sentence(20)

  users.each do |user|
    user.blogs.each do |blog|
      blog.entries.create!(title: entry_title,body: entry_body)
    end
  end
end

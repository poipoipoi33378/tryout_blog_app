require 'rails_helper'

RSpec.describe Blog, type: :model do
  it "is valid with title" do
    blog = Blog.new(title: "タイトル")
    expect(blog).to be_valid
  end

  it { is_expected.to validate_presence_of :title }

  it "is enable to save database" do
    blog = Blog.new(title: "タイトル")
    expect do
      blog.save
    end.to change(Blog, :count).by(1)
  end
end

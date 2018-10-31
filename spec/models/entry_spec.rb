require 'rails_helper'

RSpec.describe Entry, type: :model do
  let(:user){ FactoryBot.create(:user) }
  let(:blog){ Blog.create(title:"blog title",user_id: user.id) }

  it "is valid with title,body,blog_id" do
    entry = Entry.new(blog_id: blog.id,title:"title",body:"entry body")
    expect(entry).to be_valid
  end

  it { is_expected.to validate_presence_of :blog_id }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it "is belong to Blog.Blog has many entries" do
    entry = blog.entries.build(title:"entry title",body:"entry body")
    expect(entry.title).to eq "entry title"
    expect(entry.body).to eq "entry body"
    expect do
      expect do
        expect(blog.save).to be_truthy
      end.to change(Entry,:count).by(1)
    end.to_not change(Blog,:count)
  end

  it "is destroyed by Blog" do
    expect do
      blog.entries.create(title:"entry title",body:"entry body")
    end.to change(Entry,:count).by(1)

    expect do
      Blog.destroy(blog.id)
    end.to change(Entry,:count).by(-1)
  end

  it "is associated by blog" do
    blog.entries.create(title:"entry title",body:"entry body")

    expect(Entry.first.blog).to eq blog
  end

  context "factory test" do
    it "is destroyed by Blog" do
      expect do
        blog.entries.create(title:"entry title",body:"entry body")
        expect(blog.entries.first.title).to eq "entry title"
        expect(blog.entries.first.body).to eq "entry body"

      end.to change(Entry,:count).by(1)

      expect do
        Blog.destroy(blog.id)
      end.to change(Entry,:count).by(-1)
    end
  end
end

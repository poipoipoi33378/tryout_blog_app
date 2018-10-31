require 'rails_helper'

RSpec.describe Blog, type: :model do
  let(:user){ FactoryBot.create(:user) }
  let(:blog){ Blog.new(title: "タイトル",user_id: user.id) }

  it "is valid with title" do
    expect(blog).to be_valid
  end

  it { is_expected.to validate_presence_of :title }

  it "is enable to save database" do
    expect do
      blog.save
    end.to change(Blog, :count).by(1)
  end
end

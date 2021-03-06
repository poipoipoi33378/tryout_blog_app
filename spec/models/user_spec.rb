require 'rails_helper'

RSpec.describe User, type: :model do

  it 'is valid' do
    expect do
      user = User.create(name:'test',email:'tester@email.com',password: 'foobar')
      expect(user).to be_valid
    end.to change(User,:count).by(1)
  end

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_length_of(:name).is_at_most(50) }


  it 'has blogs' do
    user = User.create(name:'test',email:'tester@email.com',password: 'foobar')
    blog = user.blogs.build(title: 'test')
    expect(blog).to be_valid
  end

  context 'factory user' do
    it 'is valid' do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end

    it "is invalid with a duplicate email address" do
      FactoryBot.create(:user,email: 'test@email.com')
      user = FactoryBot.build(:user,email: 'test@email.com')
      user.valid?
      expect(user.errors[:email]).to include("has already been taken")
    end

  end
end

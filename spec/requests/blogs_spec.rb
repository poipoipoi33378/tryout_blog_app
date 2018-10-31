require 'rails_helper'

RSpec.describe "Blogs", type: :request do

  let(:user){ FactoryBot.create(:user) }
  let(:blog){ Blog.first }
  let(:entry){ Blog.second.entries.first }

  before do
    3.times do
      blog = FactoryBot.create(:blog)
      2.times do
        entry = FactoryBot.create(:entry,blog_id: blog.id)
        2.times do
          FactoryBot.create(:comment,entry_id:entry.id)
        end
      end
    end
    expect(Blog.count).to eq 3
    expect(Entry.count).to eq 6
    expect(Comment.count).to eq 12
  end

  context "destroy" do
    it "destroy associated entries and comments" do
      expect do
        expect do
          expect do
            delete blog_path(blog)
            expect(response).to have_http_status(302)
          end.to change(Comment,:count).by(-4)
        end.to change(Entry,:count).by(-2)
      end.to change(Blog,:count).by(-1)
    end

    it "and entry destroy associated comments" do
      expect do
        expect do
          expect do
            delete entry_path(entry)
            expect(response).to have_http_status(302)
          end.to change(Comment,:count).by(-2)
        end.to change(Entry,:count).by(-1)
      end.to_not change(Blog,:count)
    end
  end

  it "work index" do
    get blogs_path(blog)
    expect(response).to have_http_status(:ok)
  end

  it "work new" do
    get new_blog_path
    expect(response).to have_http_status(:ok)
  end

  it "work create" do
    sign_in user
    post blogs_path(blog),params: {blog: FactoryBot.attributes_for(:blog)}
    expect(response).to have_http_status(:found)
  end

  it "work edit" do
    get edit_blog_path(blog)
    expect(response).to have_http_status(:ok)
  end

  it "work update" do
    patch blog_path(blog),params: {blog: FactoryBot.attributes_for(:blog)}
    expect(response).to have_http_status(:found)
  end

  it "work destroy" do
    delete blog_path(blog)
    expect(response).to have_http_status(:found)
  end

  it "work show" do
    get blog_path(blog)
    expect(response).to have_http_status(:ok)
  end

end

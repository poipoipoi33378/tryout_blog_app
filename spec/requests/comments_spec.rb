require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:blog){Blog.first}
  let(:entry){Blog.second.entries.first}
  let(:comment){Blog.second.entries.second.comments.first}

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

  it "not work index" do
    expect do
      get entry_comments_path(comment)
    end.to raise_error(ActionController::RoutingError)
  end

  it "not work new" do
    expect do
      get new_entry_comments_path(comment)
    end.to raise_error(StandardError)
  end

  it "work create" do
    post entry_comments_path(entry),params: {comment: FactoryBot.attributes_for(:comment)}
    expect(response).to have_http_status(:found)
  end

  it "not work edit" do
    expect do
      get edit_comment_path(comment)
    end.to raise_error(StandardError)
  end

  it "work update" do
    patch comment_path(comment)
    expect(response).to have_http_status(:found)
  end

  it "work destroy" do
    delete comment_path(comment)
    expect(response).to have_http_status(:found)
  end

  it "not work show" do
    expect do
      get comment_path(comment)
    end.to raise_error(ActionController::RoutingError)
  end
end

require 'rails_helper'

RSpec.describe "Entries", type: :request do

  let(:blog){Blog.first}
  let(:entry){Blog.second.entries.first}

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
      get blog_entries_path(blog)
    end.to raise_error(ActionController::RoutingError)
  end

  it "work new" do
    get new_blog_entry_path(blog)
    expect(response).to have_http_status(:ok)
  end

  it "work create" do
    post blog_entries_path(blog),params: {entry: FactoryBot.attributes_for(:entry)}
    expect(response).to have_http_status(:found)
  end

  it "work edit" do
    get edit_entry_path(entry)
    expect(response).to have_http_status(:ok)

  end
  it "work update"

  it "work destroy"
  it "work show"
end

require 'rails_helper'

RSpec.describe "Blogs", type: :request do
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
      target_blog = Blog.second
      expect do
        expect do
          expect do
            delete blog_path(target_blog)
            expect(response).to have_http_status(302)
          end.to change(Comment,:count).by(-4)
        end.to change(Entry,:count).by(-2)
      end.to change(Blog,:count).by(-1)
    end

    it "and entry destroy associated comments" do
      target_entry = Entry.second
      expect do
        expect do
          expect do
            delete entry_path(target_entry)
            expect(response).to have_http_status(302)
          end.to change(Comment,:count).by(-2)
        end.to change(Entry,:count).by(-1)
      end.to_not change(Blog,:count)
    end
  end
end

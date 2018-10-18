require 'rails_helper'

RSpec.describe Comment, type: :model do
  context "Entry" do
    it "is valid with body and approved" do
      FactoryBot.create(:blog,id: 1)
      FactoryBot.create(:entry,blog_id: 1,id: 1)
      comment = Comment.new(entry_id: 1,body: "Comment")
      expect(comment).to be_valid
      expect(comment.approved).to be_falsey
    end

    it { is_expected.to validate_presence_of :entry_id }
    it { is_expected.to validate_presence_of :body }

    it "is belong to Entry.Entry has many comments" do
      blog = Blog.create(title:"blog title")
      entry = blog.entries.create(title:"entry title",body:"entry body")
      comment = entry.comments.build(body: "comment")
      expect(comment.body).to eq "comment"
      expect(comment.approved).to be_falsey
      expect do
        expect do
          expect do
            expect(entry.save).to be_truthy
          end.to change(Comment,:count).by(1)
        end.to_not change(Entry,:count)
      end.to_not change(Blog,:count)
    end

    it "is destroyed by Blog" do
      blog = Blog.create(title:"blog title")
      entry = blog.entries.create(title:"entry title",body:"entry body")
      entry.comments.create(body:"comment")
      expect(Comment.count).to eq 1

      expect do
        Blog.destroy(blog.id)
      end.to change(Comment,:count).by(-1)
    end

    it "is associated by blog" do
      blog = Blog.create(title:"blog title")
      entry = blog.entries.create(title:"entry title",body:"entry body")
      entry.comments.create(body:"comment")

      expect(Comment.first.entry.blog).to eq blog
    end
  end

   context "factory" do
     it "create valid comment" do
       blog = FactoryBot.create(:blog)
       entry = blog.entries.create(FactoryBot.build(:entry).attributes)
       comment = FactoryBot.create(:comment,entry_id: entry.id)
       expect(comment).to be_valid
     end

     it "is destroyed by Blog" do
       blog = FactoryBot.create(:blog)
       entry = blog.entries.create(title:"entry title",body:"entry body")
       entry.comments.create(body:"comment")
       expect(Comment.count).to eq 1

       expect do
         Blog.destroy(blog.id)
       end.to change(Comment,:count).by(-1)
     end
   end
end

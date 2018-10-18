require 'rails_helper'

RSpec.feature "Comments", type: :feature do

  before do
    FactoryBot.create(:blog)
    @blog = FactoryBot.create(:blog)
    entries = [FactoryBot.build(:entry),FactoryBot.build(:entry)]
    entries.each do |entry|
      @blog.entries.create(title: entry.title, body: entry.body)
    end
    @entry = @blog.entries.second

    visit root_path
    click_link 'Show', href: blog_path(@blog)
    click_link 'Show', href: blog_entry_path(@blog,@entry)
  end

  scenario "user show created entry and comments" do
    aggregate_failures do
      expect(page).to have_content "#{@blog.title}"
      expect(page).to have_content "Title:#{@entry.title}"
      expect(page).to have_content "Body:#{@entry.body}"
      expect(page).to have_link 'Edit',href: edit_blog_entry_path(@blog,@entry)
      expect(page).to have_link 'Back',href: blog_path(@blog)

      expect(page).to have_content "Listing comments"
      expect(page).to have_content "Body"
    end
  end

end

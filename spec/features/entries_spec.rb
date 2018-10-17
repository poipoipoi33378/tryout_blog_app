require 'rails_helper'

RSpec.feature "Entries", type: :feature do

  before do
    FactoryBot.create(:blog)
    @blog = FactoryBot.create(:blog)
    entries = [FactoryBot.build(:entry),FactoryBot.build(:entry)]
    entries.each do |entry|
      @blog.entries.create(title: entry.title, body: entry.body)
    end
    @entry1 = @blog.entries.first
    @entry2 = @blog.entries.second

    visit root_path
    click_link 'Show', href: blog_path(@blog)
  end

  scenario "user delete entry" ,js: true do
    expect do
      expect do
        click_link 'Destroy', href: entry_path(@entry2)
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "Entry deleted"
      end.to change(Entry,:count).by(-1)
    end.to_not change(Blog,:count)

    expect(page).to have_content @entry1.title
    expect(page).to_not have_content @entry2.title
  end

  scenario "user create new entry. An error occurs if the title or body is blank " do
    click_link 'New Entry'

    expect(page).to have_content "New entry:#{@blog.title}"

    expect do
      fill_in "Title",with: ''
      fill_in "Body",with: ''
      click_button "Save"
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end.to_not change(Entry,:count)

    entry = FactoryBot.build(:entry)
    expect do
      fill_in "Title",with: entry.title
      fill_in "Body",with: entry.body
      click_button "Save"
      expect(page).to have_content "Entry created"
    end.to change(Entry,:count).by(1)

    expect(page).to have_content @entry1.title
    expect(page).to have_content @entry2.title
    expect(page).to have_content entry.title
  end

  scenario "user edit title and body" do
    update_title = "Update Title"
    update_body = "Update Body"

    click_link 'Edit', href: edit_blog_entry_path(@blog,@entry2)
    expect do
      expect(page).to have_content 'Edit entry'
      fill_in "Title",with: update_title
      fill_in "Body",with: update_body
      click_button "Save"
    end.to_not change(Entry,:count)

    expect(page).to have_content @entry1.title
    expect(page).to have_content update_title
    expect(page).to have_content update_body
  end

  scenario "user show created entry title and body" do
    click_link 'Show', href: blog_entry_path(@blog,@entry2)

    aggregate_failures do
      expect(page).to have_content "#{@blog.title}"
      expect(page).to have_content "Title:#{@entry2.title}"
      expect(page).to have_content "Body:#{@entry2.body}"
      expect(page).to have_link 'Edit',href: edit_blog_entry_path(@blog,@entry2)
      expect(page).to have_link 'Back',href: blog_path(@blog)

      expect(page).to have_content "Listing comments"
    end
  end

end

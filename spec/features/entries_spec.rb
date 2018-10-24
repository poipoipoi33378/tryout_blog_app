require 'rails_helper'

RSpec.feature "Entries", type: :feature do

  let(:entry1){ @blog.entries.first }
  let(:entry2){ @blog.entries.second }

  before do
    FactoryBot.create(:blog)
    @blog = FactoryBot.create(:blog) do |blog|
      2.times do
        blog.entries.create(FactoryBot.attributes_for(:entry))
      end
    end

    visit root_path
    click_link 'Show', href: blog_path(@blog)
  end

  scenario "user destroy entry" ,js: true do
    expect do
      expect do
        click_link 'Destroy', href: entry_path(entry2)
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "Entry deleted"
      end.to change(Entry,:count).by(-1)
    end.to_not change(Blog,:count)

    expect(page).to have_content entry1.title
    expect(page).to_not have_content entry2.title
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

    expect(page).to have_content entry1.title
    expect(page).to have_content entry2.title
    expect(page).to have_content entry.title
  end

  scenario "user edit title and body" do
    update_title = "Update Title"
    update_body = "Update Body"

    click_link 'Edit', href: edit_entry_path(entry2)
    expect do
      expect(page).to have_content 'Edit entry'
      fill_in "Title",with: update_title
      fill_in "Body",with: update_body
      click_button "Save"
    end.to_not change(Entry,:count)

    expect(page).to have_content entry1.title
    expect(page).to have_content update_title
    expect(page).to have_content update_body
  end

end

require 'rails_helper'

RSpec.feature "Entries", type: :feature do

  before do
    @blog1 = FactoryBot.create(:blog)
    @blog2 = FactoryBot.create(:blog)
    entries = [FactoryBot.build(:entry),FactoryBot.build(:entry)]
    entries.each do |entry|
      @blog2.entries.create(title: entry.title,body: entry.body)
    end
    @entry1 = @blog2.entries.first
    @entry2 = @blog2.entries.second
  end

  scenario "user delete entry" ,js: true do
    visit root_path
    click_link 'Show', href: blog_path(@blog2)

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
    visit root_path
    click_link 'Show', href: blog_path(@blog2)

    click_link 'New Entry'

    expect(page).to have_content "New entry:#{@blog2.title}"

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

end

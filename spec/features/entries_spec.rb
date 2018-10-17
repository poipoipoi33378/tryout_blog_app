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

    visit root_path
    click_link 'Show', href: blog_path(@blog2)
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

end

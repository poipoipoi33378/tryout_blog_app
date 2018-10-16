require 'rails_helper'

RSpec.feature "Blogs", type: :feature do

  before do
    @blog1 = FactoryBot.create(:blog)
    @blog2 = FactoryBot.create(:blog)
  end

  scenario "user show blog index" do
    visit root_path

    expect(page).to have_content @blog1.title
    expect(page).to have_content @blog2.title
  end

  scenario "user delete blog title" ,js: true do
    visit root_path

    expect do
      click_link 'Destroy', href: blog_path(@blog2)
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content "Blog deleted"
    end.to change(Blog,:count).by(-1)

    expect(page).to have_content @blog1.title
    expect(page).to_not have_content @blog2.title
  end

  scenario "user create new title. An error occurs if the title is blank " do
    blog = FactoryBot.build(:blog)
    visit root_path

    click_link 'New Blog'

    expect do
      fill_in "Title",with: ''
      click_button "Save"
      expect(page).to have_content "can't be blank"
      save_and_open_page
    end.to_not change(Blog,:count)

    expect do
      fill_in "Title",with: blog.title
      click_button "Save"
    end.to change(Blog,:count).by(1)

    expect(page).to have_content @blog1.title
    expect(page).to have_content @blog2.title
    expect(page).to have_content blog.title
  end

  scenario "user edit title"
  scenario "user show created blog title"
end

require 'rails_helper'

RSpec.feature "Blogs", type: :feature do

  before do
    @blog1 = FactoryBot.create(:blog)
    @blog2 = FactoryBot.create(:blog)

    visit root_path
  end

  scenario "user show blog index" do
    expect(page).to have_content @blog1.title
    expect(page).to have_content @blog2.title
  end

  scenario "user delete blog title" ,js: true do
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
    click_link 'New Blog'

    expect do
      expect(page).to have_content 'New blog'
      fill_in "Title",with: ''
      click_button "Save"
      expect(page).to have_content "can't be blank"
    end.to_not change(Blog,:count)

    expect do
      fill_in "Title",with: blog.title
      click_button "Save"
    end.to change(Blog,:count).by(1)

    expect(page).to have_content @blog1.title
    expect(page).to have_content @blog2.title
    expect(page).to have_content blog.title
  end

  scenario "user edit title" do
    update_title = "Update Title"

    click_link 'Edit', href: edit_blog_path(@blog2)
    expect do
      expect(page).to have_content 'Edit blog'
      fill_in "Title",with: update_title
      click_button "Save"
    end.to_not change(Blog,:count)

    expect(page).to have_content @blog1.title
    expect(page).to have_content update_title
  end

  scenario "user show created blog title" do

    expect(page).to have_content @blog1.title
    expect(page).to have_content @blog2.title

    click_link 'Show', href: blog_path(@blog2)

    expect(page).to have_content "Title:#{@blog2.title}"
    expect(page).to have_link 'Edit',href: edit_blog_path(@blog2)
    expect(page).to have_link 'Back',href: blogs_path
  end
end

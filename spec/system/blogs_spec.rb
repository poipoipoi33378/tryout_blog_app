require 'rails_helper'

RSpec.feature "Blogs", type: :system do

  let(:user){ FactoryBot.create(:user) }

  background do
    @blog1 = FactoryBot.create(:blog,user_id: user.id)
    @blog = FactoryBot.create(:blog,user_id: user.id)

    sign_in user
    visit blogs_path
  end

  scenario "user show blog index" do

    Blog.all.each do |blog|
      expect(page).to have_content blog.title
      expect(page).to have_link blog.user.name
      expect(page).to have_link "Show",href: blog_path(blog)
      expect(page).to have_link "Edit",href: edit_blog_path(blog)
      expect(page).to have_link "Destroy",href: blog_path(blog)
    end

    30.times do
      FactoryBot.create(:blog,user_id: user.id)
    end

    visit blogs_path
    expect(page).to have_content 'Next'
    expect(page).to have_content 'Previous'
  end

  scenario "user delete blog title" ,js: true do
    expect do
      click_link 'Destroy', href: blog_path(@blog)
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content "Blog deleted"
    end.to change(Blog,:count).by(-1)

    expect(page).to have_content @blog1.title
    expect(page).to_not have_content @blog.title
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
    expect(page).to have_content @blog.title
    expect(page).to have_content blog.title
  end

  scenario "user edit title" do
    update_title = "Update Title"

    click_link 'Edit', href: edit_blog_path(@blog)
    expect do
      expect(page).to have_content 'Edit blog'
      fill_in "Title",with: update_title
      click_button "Save"
    end.to_not change(Blog,:count)

    expect(page).to have_content @blog1.title
    expect(page).to have_content update_title
  end

  scenario "user show created blog title and blog entries" do

    entries = [FactoryBot.build(:entry),FactoryBot.build(:entry)]
    entries.each do |entry|
      @blog.entries.create(title: entry.title, body: entry.body)
    end

    click_link 'Show', href: blog_path(@blog)

    expect(page).to have_content "Title:#{@blog.title}"
    expect(page).to have_link 'Edit',href: edit_blog_path(@blog)
    expect(page).to have_link 'Back',href: blogs_path

    expect(page).to have_content "Listing entries"

    expect(page).to have_content "Title"
    expect(page).to have_content "Body"

    @blog.entries.each do |entry|
      aggregate_failures do
        expect(page).to have_content entry.title
        expect(page).to have_content entry.body
        expect(page).to have_link entry.blog.user.name
        expect(page).to have_link "Show",href: entry_path(entry)
        expect(page).to have_link "Edit",href: edit_entry_path(entry)
        expect(page).to have_link "Destroy",href: entry_path(entry)
      end
    end

    expect(page).to have_link 'New Entry',href: new_blog_entry_path(@blog)

    30.times do
      @blog.entries.create(FactoryBot.attributes_for(:entry))
    end

    visit blogs_path
    click_link 'Show', href: blog_path(@blog)

    expect(page).to have_content 'Next'
    expect(page).to have_content 'Previous'
  end
end

require 'rails_helper'

RSpec.feature "Comments", type: :feature do

  before do
    FactoryBot.create(:blog)
    @blog = FactoryBot.create(:blog)
    @entry = FactoryBot.create(:entry,:with_5_comments,blog_id: @blog.id)
    expect(@entry.comments.length).to eq 5

    visit root_path
    click_link 'Show', href: blog_path(@blog)
    click_link 'Show', href: entry_path(@entry)
  end

  scenario "user show created entry and comments" do
    aggregate_failures do
      expect(page).to have_content "#{@blog.title}"
      expect(page).to have_content "Title:#{@entry.title}"
      expect(page).to have_content "Body:#{@entry.body}"
      expect(page).to have_link 'Edit',href: edit_entry_path(@entry)
      expect(page).to have_link 'Back',href: blog_path(@blog)

      expect(page).to have_content "Listing comments"

      within '.section-comment' do
        expect(page).to have_content "Body"
      end
    end

    aggregate_failures do
      @entry.comments.each do |comment|
        expect(page).to have_content comment.body
        expect(page).to have_link "Destroy",href: comment_path(comment)
      end
    end

    within '.section-comment-new' do
      expect(page).to have_content "Body"
      expect(page).to have_content "New comment"
      expect(page).to have_button "Save"
    end
  end

  scenario "user destroy comment" ,js: true do
    test_comment = @entry.comments.second
    expect do
      expect do
        click_link 'Destroy', href: comment_path(test_comment)
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "Comment deleted"
      end.to change(Comment,:count).by(-1)
    end.to_not change(Entry,:count)

    @entry.comments.each do |comment|
      if comment == test_comment
        expect(page).to_not have_content comment.body
        expect(page).to_not have_link "Destroy",href: comment_path(comment)
      else
        expect(page).to have_content comment.body
        expect(page).to have_link "Destroy",href: comment_path(comment)
      end
    end
  end

  scenario "user create new comment"  do

    expect do
      fill_in "Body",with: ''
      click_button "Save"
      expect(page).to have_content "can't be blank"
    end.to_not change(Comment,:count)

    expect do
      fill_in "Body",with: 'New Comment Test'
      click_button "Save"
    end.to change(Comment,:count).by(1)

    @entry.comments.each do |comment|
      expect(page).to have_content comment.body
      expect(page).to have_link "Destroy",href: comment_path(comment)
    end

    expect(page).to_not have_content "New Comment Test"
    expect(page).to have_content '(承認待ち)'

    click_link 'Approve'

    aggregate_failures do
      expect(page).to have_content "New Comment Test"
      expect(page).to_not have_content '(承認待ち)'
    end
  end
end

require 'rails_helper'

RSpec.feature 'Comments', type: :system do
  include ActiveJob::TestHelper

  scenario "send email when comment is added " do

    entry = FactoryBot.create(:entry)

    visit root_path
    click_link 'Show', href: blog_path(entry.blog)
    click_link 'Show', href: entry_path(entry)

    perform_enqueued_jobs do
      expect do
        fill_in "Body",with: 'New Comment Test'
        click_button "Save"
      end.to change(Comment,:count).by(1)
    end

    mail = ActionMailer::Base.deliveries.last

    aggregate_failures do
      expect(mail.subject).to eq("新しいコメントが投稿されました")
      expect(mail.to).to eq(["poipoipoi33378@gmail.com"])
      expect(mail.from).to eq(["noreply@example.com"])

      expect(mail.html_part.decoded).to match("新しいコメントが登録されました。")
      expect(mail.html_part.decoded).to match("承認または削除してください。")
      expect(mail.html_part.decoded).to match("Blog:#{entry.blog.title}")
      expect(mail.html_part.decoded).to match("Entry:#{entry.title}")
      expect(mail.html_part.decoded).to match("Comment:New Comment Test")
    end

  end
end

require "rails_helper"

RSpec.describe NoticeMailer, type: :mailer do
  describe "sendmail_confirm" do

    let(:comment){ FactoryBot.create(:comment)}
    let(:mail) { NoticeMailer.sendmail_confirm(comment) }

    it "renders the headers" do
      expect(mail.subject).to eq("新しいコメントが投稿されました")
      expect(mail.to).to eq(["poipoipoi33378@gmail.com"])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      aggregate_failures do
        p mail.body.encoded
        expect(mail.body.encoded).to match("新しいコメントが登録されました。")
        # expect(mail.body.encoded).to match("承認または削除してください。")
        # expect(mail.body.encoded).to match("Blog:#{comment.entry.blog.title}")
        # expect(mail.body.encoded).to match("Entry:#{comment.entry.title}")
        # expect(mail.body.encoded).to match("Comment:#{comment.body}")
        expect(mail.html_part.decoded).to match("新しいコメントが登録されました。")
        expect(mail.html_part.decoded).to match("承認または削除してください。")
        expect(mail.html_part.decoded).to match("Blog:#{comment.entry.blog.title}")
        expect(mail.html_part.decoded).to match("Entry:#{comment.entry.title}")
        expect(mail.html_part.decoded).to match("Comment:#{comment.body}")
        expect(mail.html_part.decoded).to match(comment.body)
      end
    end
  end

end

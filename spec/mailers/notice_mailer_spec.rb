require "rails_helper"

RSpec.describe NoticeMailer, type: :mailer do
  describe "sendmail_confirm" do

    let(:comment){ FactoryBot.create(:comment)}
    let(:mail) { NoticeMailer.sendmail_confirm(comment) }

    it "renders the headers" do
      expect(mail.subject).to eq("新しいコメントが投稿されました")
      expect(mail.to).to eq(["poipoipoi33378@gmail.com"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end

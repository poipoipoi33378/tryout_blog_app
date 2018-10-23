# Preview all emails at http://localhost:3000/rails/mailers/notice_mailer
class NoticeMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notice_mailer/sendmail_confirm
  def sendmail_confirm
    comment = Comment.first
    NoticeMailer.sendmail_confirm(comment)
  end

end

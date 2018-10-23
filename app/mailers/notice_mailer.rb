class NoticeMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notice_mailer.sendmail_confirm.subject
  #
  def sendmail_confirm(comment)
    @comment = comment

    mail to: "poipoipoipoi33378@gmail.com"
  end
end

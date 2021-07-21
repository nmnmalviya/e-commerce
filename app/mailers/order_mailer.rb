class OrderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.order_created.subject
  #
  def order_created
    @mail=params[:mail]
    @greeting = "Hi"

    mail to: @mail,subject:"order place"
  end
end

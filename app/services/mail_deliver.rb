class MailDeliver
  def initialize(args)
    @user = args[:user]
    @expense = args[:expense]
  end

  def process
    ExpenseMailer.new(address: 'admin@expensr.com', body: email_body).deliver
  end
  private
  def email_body
    "#{@expense.name} by #{@user.full_name} needs to be approved"
  end
end

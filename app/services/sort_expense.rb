class SortExpense
  def initialize(args)
    @params = args[:params]
    @user = args[:user]
    @expenses = args[:expenses]
  end

  def return_results
    maybe_approved.return_users
  end
  private
  def maybe_approved
    @params[:approved].nil? ? NotApproved.new(user: @user) :
      Approved.new(user: @user, params: @params)
  end
end

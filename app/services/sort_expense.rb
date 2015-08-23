class SortExpense
  def initialize(args)
    @user = args[:user]
    @approved = args[:approved]
    @min_amount = args[:min_amount]
    @max_amount = args[:max_amount]
  end

  def return_results
    expenses = Expense.not_deleted(@user)
    expenses = expenses.where(approved: @approved) unless @approved.nil?
    expenses = expenses.more_than(@min_amount) unless @min_amount.nil?
    expenses = expenses.less_than(@max_amount) unless @max_amount.nil?
    expenses
  end
end

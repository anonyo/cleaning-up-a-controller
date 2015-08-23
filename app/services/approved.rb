class Approved < SortExpense
  def return_users
    Expense.approved_user(@user, @params[:approved])
  end
end

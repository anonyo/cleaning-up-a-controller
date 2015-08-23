class NotApproved < SortExpense
  def return_users
    Expense.pending_users(@user)
  end
end

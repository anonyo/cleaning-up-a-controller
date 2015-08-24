class ApproveExpense < Struct.new(:expense)
  def process
    expense.update_attributes!(approved: true)
  end
end

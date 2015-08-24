class DestroyExpense < Struct.new(:expense)
  def process
    expense.update_attributes!(deleted: true)
  end
end

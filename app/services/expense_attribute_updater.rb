class ExpenseAttributeUpdater
  attr_reader :expense_params
  def initialize(args)
    @expense_params = args[:expense_params]
    @expense = args[:expense]
  end
  def process
    @expense.update_attributes!(expense_params)
  end
end

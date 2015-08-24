require 'spec_helper'

describe DestroyExpense do
  describe '#process' do
    let!(:expense) { create(:expense, :not_deleted) }
    it 'deletes an expense' do
      delete_expense = DestroyExpense.new(expense)

      expect {
        delete_expense.process }.to change { expense.deleted }.from(false).to(true)
    end
  end
end


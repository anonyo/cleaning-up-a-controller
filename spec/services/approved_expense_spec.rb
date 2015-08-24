require 'spec_helper'

describe ApproveExpense do
  describe '#process' do
    let!(:expense) { create(:expense, :unapproved) }
    it 'approved an expense' do
      approve_expense = ApproveExpense.new(expense)

      expect {
        approve_expense.process }.to change { expense.approved }.from(false).to(true)
    end
  end
end

require 'spec_helper'

describe SortExpense do
  describe '#perform' do
    let!(:user) { create(:user) }
    let!(:approved_expense) { create(:expense, :approved) }
    let!(:unapproved_expense) { create(:expense, :unapproved) }

     it 'sorts expenses' do
       sort_expense = SortExpense.new(user: approved_expense.user,
                                      approved: nil,
                                      min_amount: 12.0,
                                      max_amount: 99.9)
       expect(sort_expense.return_results).to include approved_expense
    end
  end
end

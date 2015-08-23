class ExpensesController < ApplicationController
  before_filter :user, only: [:index, :new, :create]
  before_filter :user_expense, only: [:update]
  before_filter :expense, only: [:update]

  def index
    args = {
      user:       @user,
      approved:   params[:approved],
      min_amount: params[:min_amount],
      max_amount: params[:max_amount]
    }
    @expenses = SortExpense.new(args).return_results
  end

  def new
    @user
  end

  def create
    @expense = user.expenses.new(expense_params)
    if @expense.save
      email_body = "#{@expense.name} by #{user.full_name} needs to be approved"
      mailer = ExpenseMailer.new(address: 'admin@expensr.com', body: email_body)
      mailer.deliver

      redirect_to user_expenses_path(user)
    else
      render :new, status: :bad_request
    end
  end

  def update

    unless @expense.approved
      @expense.update_attributes!(expense_params)
      flash[:notice] = 'Your expense has been successfully updated'
      redirect_to user_expenses_path(user_id: user.id)
    else
      flash[:error] = 'You cannot update an approved expense'
      render :edit
    end
  end

  def approve
    @expense = Expense.find(params[:expense_id])
    @expense.update_attributes!(approved: true)

    render :show
  end

  def destroy
    expense = Expense.find(params[:id])
    user = User.find(params[:user_id])
    expense.update_attributes!(deleted: true)

    redirect_to user_expenses_path(user_id: user.id)
  end

  private

  def expense_params
    params.require(:expense).permit(:name, :amount, :approved)
  end

  def min_amount
    params[:min_amount].nil?
  end

  def max_amount
    params[:max_amount].nil?
  end

  def user
    @user ||= User.find(params[:user_id])
  end

  def expense
    @expense = user.expenses.find(params[:id])
  end
end

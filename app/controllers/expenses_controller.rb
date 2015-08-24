class ExpensesController < ApplicationController
  before_action :find_user, only: [:index, :new, :create, :update, :destroy]
  before_action :add_expense_to_user, only: :create
  before_action :find_user_expense, only: :update
  before_action :find_expense, only: :approve
  before_action :expense, only: :destroy

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
    args = {
      user: @user,
      expense: @expense
    }

    if @expense.save
      MailDeliver.new(args).process

      redirect_to user_expenses_path(@user)
    else
      render :new, status: :bad_request
    end
  end

  def update
    args = {expense: @expense,
            expense_params: expense_params}

    unless @expense.approved
     ExpenseAttributeUpdater.new(args).process
      flash[:notice] = 'Your expense has been successfully updated'
      redirect_to user_expenses_path(user_id: @user.id)
    else
      flash[:error] = 'You cannot update an approved expense'
      render :edit
    end
  end

  def approve
    ApproveExpense.new(@expense).process
    render :show
  end

  def destroy
    DestroyExpense.new(expense).process
    redirect_to user_expenses_path(user_id: @user.id)
  end

  private

  def expense_params
    params.require(:expense).permit(:name, :amount, :approved)
  end

  def find_user
    @user ||= User.find(params[:user_id])
  end
   def add_expense_to_user
    @expense = @user.expenses.new(expense_params)
  end
   def find_user_expense
    @expense = @user.expenses.find(params[:id])
  end

  def find_expense
    @expense = Expense.find(params[:expense_id])
  end

  def expense
    @expense ||= Expense.find(params[:id])
  end
end

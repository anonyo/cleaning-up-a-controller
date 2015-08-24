class ExpensesController < ApplicationController
  before_action :find_user, only: [:index, :new, :create, :update, :destroy]
  before_action :add_expense_to_user, only: :create
  before_action :find_user_expense, only: :update

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

    unless find_user_expense.approved
      find_user_expense.update_attributes!(expense_params)
      flash[:notice] = 'Your expense has been successfully updated'
      redirect_to user_expenses_path(user_id: @user.id)
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

  def find_user
    @user ||= User.find(params[:user_id])
  end
   def add_expense_to_user
    @expense = @user.expenses.new(expense_params)
  end
   def find_user_expense
    @expense = @user.expenses.find(params[:id])
  end
end

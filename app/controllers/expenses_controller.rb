class ExpensesController < ApplicationController
  before_filter :user, only: [:index, :new, :create]
  def index
    @expenses = SortExpense.new(params: params, user: @user).return_results

    @expenses = @expenses.more_than(params[:min_amount]) unless min_amount

    @expenses = @expenses.less_than(params[:max_amount]) unless max_amount
  end

  def new
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
    user = User.find(params[:user_id])

    @expense = user.expenses.find(params[:id])

    if !@expense.approved
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
end

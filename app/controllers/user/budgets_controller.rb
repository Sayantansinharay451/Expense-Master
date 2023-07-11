class User::BudgetsController < ApplicationController
  layout "user"

  def index
      @budgets = budgets_create_by(Current.user)
  end

  def new
    @budget = Budget.new
  end

  def create
    @budget = Budget.new(budget_params)

    if @budget.save
      redirect_to budgets_path, notice: "Budget created successfully."
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def budget_params
    params.require(:budget).permit(:category_id, :subcategory_id, :amount, :notes, :month)
  end
end

class ProblemsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]

  def new
    @problem = current_user.problems.build if logged_in?
  end

  def create
    @problem = current_user.problems.build(problem_params)
    if @problem.save
      flash[:success] = "Problem added!"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @problem.update_attributes(problem_params)
      flash[:success] = "Problem updated"
      redirect_to current_user
    else
      render 'edit'
    end
  end

  def destroy
    @problem.destroy
    flash[:success] = "Problem deleted"
    redirect_to request.referrer || root_url
  end

  private

    def problem_params
      params.require(:problem).permit(:name, :url)
    end

    def correct_user
      @problem = current_user.problems.find_by(id: params[:id])
      redirect_to root_url if @problem.nil?
    end
end

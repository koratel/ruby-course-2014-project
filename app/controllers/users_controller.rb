class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :add_codeforces_problems]
  before_action :correct_user,   only: [:edit, :update, :add_codeforces_problems]
  before_action :admin_user,     only: :destroy

  include ActionView::Helpers::TextHelper
  require 'open-uri'

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @problems = @user.problems.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  # Adds user problems from codeforces
  def codeforces_problems
    puts "handle: " + params[:handle]
    problems = get_codeforces_problems(params[:handle])
    user = current_user
    if problems.nil?
      flash[:warning] = "Incorrect handle"
      redirect_to user and return
    end
    cf_url = "http://codeforces.com/contest/"
    old_count = user.problems.count
    problems.each do |problem|
      name = problem["index"].to_s + ". " + problem["name"]
      url = cf_url + problem["contestId"].to_s + "/problem/" + problem["index"].to_s
      new_problem = user.problems.create(name: name, url: url)
      if new_problem.persisted?
        problem["tags"].each { |tag| new_problem.tags.create(name: tag.to_s) }
        new_problem.tags.create(name: "codeforces")
      end
    end
    diff = user.problems.count - old_count
    flash[ diff > 0 ? :success : :info ] = "Added " + pluralize(diff, "problem")
    redirect_to user
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    def get_codeforces_problems(handle)
      api_url = "http://codeforces.com/api/user.status?handle="
      begin
        data =  open(api_url + handle).read
        parsed_data = JSON.parse(data)
        puts parsed_data
        parsed_data["result"].collect { |submission| submission["problem"] }.uniq
      rescue OpenURI::HTTPError
        nil
      end
    end

    # Before filters

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end

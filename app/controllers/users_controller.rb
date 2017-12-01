class UsersController < ApplicationController
  before_action :set_user, only: [:show, :profile_edit, :budget_edit, :profile_update, :budget_update]
  before_action :logged_in_user, only: [:profile_edit, :budget_edit, :profile_update, :budget_update, :destroy]
  before_action :correct_user,   only: [:show, :profile_edit,:budget_edit, :profile_update, :budget_update]

  # GET /users
  # GET /users.json
  def index
    return redirect_to root_path
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @lost = 0
    @rest = 0
    @img_path = image_path(@user.coin)
    books = Book.where(user: @user)
    books.each do |book|
      @lost += book.cost
    end
    #@rest = @user.budget - @lost
    @rest = inserted_cost(@user.budget - @lost)
    @lost = inserted_cost(@lost)
    @budget = inserted_cost(@user.budget)
    @books = @user.books.order("time DESC")
    @new_book = Book.new
    @send_user_wearing_clothes = Clothe::get_user_wearing_tag_hash(@user.id)
    @tags = Tag.all
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/profile_edit
  def profile_edit
      @user = User.find(params[:id])
  end

  #GET /users/1/budget_edit
  def budget_edit
      @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.coin = 0
    respond_to do |format|
      begin
        ActiveRecord::Base.transaction do
          @user.save
          initialize_clothes
        end
      log_in @user
      flash[:success] = "ようこそ家計学園へ！"
      format.html { redirect_to @user }
      format.json { render :show, status: :created, location: @user }
      rescue => e
        puts(e)
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def profile_update
    respond_to do |format|
      if @user.update(user_params)
        flash[:success] = "変更内容を更新しました！"
        format.html { redirect_to @user }
        format.json { render :show, status: :ok, location: @user }
        return redirect_to user_url @user
      else
        flash[:notice] = "なんらかのエラーが発生しました."
        format.html { render :profile_edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

    # PATCH/PUT /users/1
    # PATCH/PUT /users/1.json
    def budget_update
      respond_to do |format|
        if @user.update(user_params)
            flash[:success] = "変更内容を更新しました！"
          format.html { redirect_to @user }
          format.json { render :show, status: :ok, location: @user }
         return redirect_to user_url @user
        else
          flash[:notice] = "なんらかのエラーが発生しました."
          format.html { render :budget_edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
  end


  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
     User.find(current_user.id).destroy
     respond_to do |format|
        flash[:success] = "ご利用ありがとうございました！"
     format.html { redirect_to users_url }
     format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :budget, :coin)
    end

    def user_params_except_password
        params.require(:user).permit(:name, :email, :budget)
    end

     # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください."
        redirect_to login_path
      end
    end
        # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end

    def inserted_cost(cost)
        str_cost = cost.to_s
        cost_size = str_cost.size
        cost_size.times do |i|
            if i%3 == 0 and i != cost_size and i != 0 then
                str_cost.insert(cost_size - i, ",")
            end
        end
        return str_cost
    end

	def initialize_clothes
    UserWearing::initialized_user_wearing(@user.id)
    UserHasClothe::initialized_user_has_clothe(@user.id)
	end
end

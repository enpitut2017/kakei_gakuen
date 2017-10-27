class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user,   only: [:show, :edit, :update]

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
    @img_path = image_path(@user.level)
    books = Book.where(user: @user)
    books.each do |book|
      @lost += book.cost
    end
    #@rest = @user.budget - @lost
    @rest = inserted_cost(@user.budget - @lost)
    @lost = inserted_cost(@lost)
    @budget = inserted_cost(@user.budget)
    @books = @user.books.order("time DESC")
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
      @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.exp = 0
    @user.level = 1
    respond_to do |format|
      if @user.save
          log_in @user
          flash[:success] = "User was successfully created."
        format.html { redirect_to @user }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
          flash[:success] = "User was successfully updated."
        format.html { redirect_to @user }
        format.json { render :show, status: :ok, location: @user }
       return redirect_to user_url @user
      else
          flash[:notice] = "User updating was failed."
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

#    if @user.update_attributes(user_params)
#        flash[:success] = "User was successfully updated."
#        redirect_to user_path
#    else
#        render 'edit'
#    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
     User.find(current_user.id).destroy
     respond_to do |format|
        flash[:success] = "User was successfully deestroyed."
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
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :budget)
    end

     # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
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
end

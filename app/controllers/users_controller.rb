class UsersController < ApplicationController
  before_action :set_user, only: [:show, :profile_edit, :budget_edit, :profile_update, :budget_update]
  before_action :logged_in_user, only: [:profile_edit, :budget_edit, :profile_update, :budget_update, :destroy, :image]
  before_action :correct_user,   only: [:show, :profile_edit,:budget_edit, :profile_update, :budget_update]
  after_action :destroy_image, only: [:image]

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
    @serif = select_serif()
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
    @send_user_wearing_clothes = Clothe::get_user_wearing_tag_hash(current_user.id)
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
      if @user.save
        begin
          @user.save
          ActiveRecord::Base.transaction do
            #ここに処理を書く
            initialize_clothes
          end
          puts('success!! commit') # トランザクション処理を確定
          log_in @user
          flash[:success] = "ようこそ家計学園へ！"
          format.html { redirect_to @user }
          format.json { render :show, status: :created, location: @user }
        rescue => e
          puts('error!! rollback') # トランザクション処理を戻す
          puts e
          @user.destroy
          format.html { render :new }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
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

  def image
      @image = nil
      clothes = Clothe.where(id: UserWearing::get_user_wearing_array(current_user.id)).order(:priority)
      clothes.each do |clothe|
          path = clothe.image.url
          path = './public' + path

          tmp_image = Magick::Image.from_blob(File.read(path)).first

          if (@image.nil?)
              @image = tmp_image
          else
              @image = @image.composite(tmp_image, 0, 0, Magick::OverCompositeOp)
          end
      end

      send_data @image.to_blob, type: "image/png", disposition: 'inline'
  end

  def callback
    if (request.path_info == "/auth/twitter/callback")
      auth = request.env["omniauth.auth"]
      session[:oauth_token] = auth.credentials.token
      session[:oauth_token_secret] = auth.credentials.secret
      flash[:success] = "Oauth認証に成功しました"
      redirect_to user_path(current_user.id)
    else
      redirect_to root_path
    end
  end

  def tweet
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = Rails.application.secrets.twitter_consumer_key
      config.consumer_secret = Rails.application.secrets.twitter_consumer_secret
      config.access_token = session[:oauth_token]
      config.access_token_secret = session[:oauth_token_secret]
    end
    path = "#{Rails.root}/tmp/#{SecureRandom.hex}.png"
    File.open(path, 'wb') do |f|
      f.write(Base64.decode64(params[:image].gsub!(/data:(.*?);(?:.*?),/, '')))
	  end
	  file = File.new(path)
    client.update_with_media(params[:text], file)
    file.close()
	  File.delete(path)
    flash[:success] = "ツイートしました"
    redirect_to user_path(current_user.id)
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
    @user.update_attribute(:image, 'https://kakeigakuen-staging.xyz/user/image/' + @user.id.to_s + '/image.png')
  end

  def destroy_image
    if @image
      @image.destroy!
      puts 'image destroy'
    end
  end

  def select_serif
    f = File.open("#{Rails.public_path}/serif.txt")
    array = f.readlines
    f.close
    return array.sample.empty? ? '今日も1日がんばろう！' : array.sample
  end
end

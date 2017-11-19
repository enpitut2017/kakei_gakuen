class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :creat, :edit, :update, :destroy, :show]
  before_action :correct_user, only: [:creat, :edit, :update, :destroy, :show]

  # GET /books
  # GET /books.json
  def index
    @user = current_user
    @books = @user.books.order('time DESC')

  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  # POST /books
  # POST /books.json
  def create
    items = params[:items]
    costs = params[:costs]
    _times = params[:times]

    if items == nil || costs == nil || _times == nil then
      @book = Book.new
      @book.errors[:base] << "家計簿を入力してください"
      return render :new
    end

    @books = [];
    @user = User.find(current_user.id)

    #経験値の計算
    coin = @user.coin + culcurate_coin(_times, costs)
    @user.update_attribute(:coin, coin)

    for i in 0..items.size-1 do
        if costs[i].length >= 10 then
            next
        end
      @books.push(Book.new(item: items[i], cost: costs[i], user: @user, time: _times[i]))
    end

    respond_to do |format|
      if Book.import @books
        #flash[:success] = "Book was successfully created."
        format.html { redirect_to @user}
        format.json { render :show, status: :created, location: @books }
      else
        format.html { render :new }
        format.json { render json: @books.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
          flash[:success] = "Book was successfully updated."
          format.html { redirect_to books_path }
          format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
        flash[:success] = 'Book was successfully destroyed.'
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:item, :cost, :time, :user)
    end

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_path
      end
    end

    #正しいユーザーか確認
    def correct_user
      @user = User.find(Book.find(params[:id]).user_id)
      redirect_to user_path(current_user) unless @user == current_user
    end

    #経験値計算
    def culcurate_coin(items, costs)
        defalt_coin = 10
        times = Array.new
        d = Time.parse(Date.today.strftime("%Y-%m-%d")).to_i
        items.each do |item|
            times.push(((d-Time.parse(item).to_i)/100)/864)
        end
        times.each do |time|
            defalt_coin -= time
        end
        if defalt_coin < 1 then
            defalt_coin = 1
        end

        costs.length.times do |i|
            if costs[i].length < 10 then
                break
            end
            if i == costs.length - 1 then
                defalt_coin = 0
            end
        end

        return defalt_coin
    end
end

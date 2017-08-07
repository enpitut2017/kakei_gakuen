class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # GET /books
  # GET /books.json
  def index
    @user = current_user 
    @books = @user.books
    @books = Book.order('time DESC').page(params[:page]).per(10)
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
    @books = [];
    @user = User.find(current_user.id)
    exp = @user.exp + culcurate_exp(_times) 
    @user.update_attribute(:exp, exp)

    if items == nil || costs == nil || _times == nil then
      @book = Book.new
      @book.errors[:base] << "家計簿を入力してください"
      return render :new
    end

    for i in 0..items.size-1 do
      @books.push(Book.new(item: items[i], cost: costs[i], user: @user, time: _times[i]))
    end

    respond_to do |format|
      if Book.import @books
        format.html { redirect_to @user, notice: 'Book was successfully created.' }
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
        format.html { redirect_to books_path, notice: 'Book was successfully updated.' }
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
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
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
      params.require(:book).permit(:item, :cost, :time)
    end
end

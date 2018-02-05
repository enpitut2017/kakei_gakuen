class ApiController < ApplicationController
    protect_from_forgery :except => [:book_list, :create, :login, :image, :register_books, :register_image, :get_image_path, :download_image_by_id, :download_image_by_date, :download_image_all]
    after_action :destroy_image, only: [:image]

    require 'rmagick'

    def register_books
        response = initialize_response
        token = params[:token]
        items = params[:items]
        costs = params[:costs]
        _times = Time.zone.now

        user = User.find_by(token: token)

        if ! user then
            return render :json => no_user(response)
        end

        #ユーザー情報のセット
        response['token'] = user.token
        response['budget'] = user.budget
        response['rest'] = rest_budget(user.id)

        if items.nil? then
            response['error'] = true
            response['message']['no_item'] = '用途を入力してください'
        end

        if costs.nil? then
            response['error'] = true
            response['message']['no_cost'] = '値段を入力してください'
        end

        if ! items.kind_of?(Array)
            items = [items]
        end

        if ! costs.kind_of?(Array)
            costs = [costs]
        end

        if items.size != costs.size then
            response['error'] = true
            response['message']['size_missmatch'] = '用途と値段は正しく入力してください'
        end

        costs.each do |cost|
            if cost !~ /\d+$/ then
                response['error'] = true
                response['message']['cost_no_intger'] = '値段は数値で入力してください'
                break
            end
        end

        if response['error'] then
            return render :json => response
        end

        begin
        puts('books api start')
        ActiveRecord::Base.transaction do
            books = [];
            #経験値の計算

            puts('coin update start')

            coin = user.coin + 2 #apiの場合、コインは2コインとする #culcurate_coin(_times, costs)
            user.update_attribute(:coin, coin)

            puts('coin update')

            for i in 0..costs.size-1 do
                if costs[i].length >= 10 then
                    next
                end
                books.push(Book.new(item: items[i], cost: costs[i], user: user, time: _times.strftime('%Y-%m-%d')))
            end

            Book.import books
        end
            puts('success!! commit') # トランザクション処理を確定
            response['rest'] = rest_budget(user.id)
            response['message']['book_register_success'] = '商品の登録に成功しました'
        rescue => e
            puts e # トランザクション処理を戻す
            response['error'] = true
            response['message']['system_error'] = e
        end

        render :json => response
    end

    def book_list
      response = {
          'error' => false,
          'message' => {},
          'token' => '', 
          'list' => []
        }

      token = params[:token]
      user = User.find_by(token: token)
      if ! user
        return render :json => no_user(response)
      end
      now = Time.current
      books = Book.where(user: user).order('time DESC').where("time > ?", now.beginning_of_month).where("time < ?", now.end_of_month)
      ansbook =[]
      books.each do |book|
        ansbook.push(book)
      end

      response['token'] = user.token
      response['message']['get_list_success'] = 'listを取得しました'
      response['list'] = ansbook
      return render :json => response
    end

    def status
      response = initialize_response
      token = params[:token]
      user = User.find_by(token: token)
      if !user
        return render :json => no_user(response)
      end
      budget = user.budget
      rest = rest_budget(user.id)
      response = {'token' => token, 'budget' => budget, 'rest' => rest}
      return render :json => response
    end


    def create
        response = initialize_response
        user = User.new
        user.name = params[:name]
        user.email = params[:email]
        user.password = params[:password]
        user.password_confirmation = params[:password]
        user.budget = params[:budget]
        user.coin = 0
        user.token = Digest::SHA1.hexdigest(params[:email].downcase)
        if user.save
            initialize_clothes(user.id)
            response['message'] = '新規作成しました'
            response['token'] = user.token
            response['budget'] = user.budget
            response['rest'] = rest_budget(user.id)
        else
            response['message'] = user.errors
        end

        render :json => response
    end

    def login

        response = initialize_response
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password]) then
            if user.token.nil?
                token = Digest::SHA1.hexdigest(params[:email].downcase)
                if user.update(token: token, password: params[:password], password_confirmation: params[:password]) then
					user.token = token
                else
                    response['error'] = true
                    response['message']['system_error'] = 'システムにエラーが発生しました'
					render :json => response
					return
				end
            end
            response['message']['login_success'] = 'ログインしました'
            response['token'] = user.token
            response['budget'] = user.budget
            response['rest'] = rest_budget(user.id)
        else
            response['error'] = true
            response['message']['login_fail'] = 'emailまたはパスワードが間違っています'
        end

        render :json => response
    end

    def register_image
        puts "画像の登録"
        user = User.find(params[:id])
        user.update_attribute(:image, params[:image])
        render :json => {'token' => 'register'}
    end

	def image
		#ローカル環境のみ起動可能
		#画像を合成して書き出す
        token= params[:token]
        @image = nil
        user = User.find_by(token: token)
        if (user) then
            clothes = Clothe.where(id: UserWearing::get_user_wearing_array(user.id)).order(:priority)
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
        else
            @image = Magick::Image.from_blob(File.read('./public/error.png')).first
        end

        send_data @image.to_blob, type: "image/png", disposition: 'inline'
    end

	def get_image_path
		#現在の方法
		#tokenをpostすると現在来ている服のパスが返ってくる

        token= params[:token]
        response = {
            'error' => false,
            'message' => {},
            'token' => '', 
            'path' => [],
        }
        user = User.find_by(token: token)

        if (user) then
            clothes = Clothe.where(id: UserWearing::get_user_wearing_array(user.id)).order(:priority)
            path=[]
            clothes.each do |clothe|
                path.push(clothe.image.url)
            end
            if  ! path.empty?
                response['token'] = user.token
                response['path'] = path
            end
        else
            return :json => no_user(response)
        end

        render :json => response
	end

	def get_image_path_by_id
		#あまり推奨しない方法
	end

	def download_image_by_id
		#画像ダウンロード設定1
		#現在持っている服のidをpostすると持っていない服のidとurlの配列を返す

		token = params[:token]
		id = params[:id]

		response = {'token' => 'error', 'id' => 0, 'path' => 0}
		user = User.find_by(token: token)

		if (user) then
			clothes = Clothe.where(id: UserHasClothe.where(user_id: user.id).where.not(clothes_id: id).pluck(:clothes_id))
			id = []
			path = []
			clothes.each do |clothe|
				id.push(clothe.id)
				path.push('https://' + clothe.image.url)
			end
			response = {'token' => user.token, 'id' => id, 'path' => path}
		end

		render :json => response
	end

	def download_image_by_date
		#画像ダウンロード設定2
		#最後に同期した日付をpostするとそれ以降に購入した服urlの配列と同期した日付を返す
		#時間はサーバーに依存するため必ず受け取った時間を使うこと
		#初回更新はdateを0で送る

		token = params[:token]
		date = params[:date]

		response = {'token' => 'error', 'date' => 0, 'path' => 0}
		user = User.find_by(token: token)

		if (user) then
			clothes = Clothe.where(id: UserHasClothe.where(user_id: user.id).where("updated_at > ?", date).pluck(:clothes_id))
			path=[]
            clothes.each do |clothe|
                path.push('https://' + clothe.image.url)
			end
			response = {'token' => user.token, 'date' => Date.today, 'path' =>path}
		end

		render :json => response
	end

	def download_image_all
		#postされたid以降の画像をすべてダウンロードする
		#初回は0

		id = params[:id]

		response = {'id' => 0, 'path' => 0}

		clothes = Clothe.where("id > ?", id)
		if clothes.empty? then
			response = {'id' => id, 'path' => 0}
		else
			path=[]
			clothes.each do |clothe|
				path.push('https://' + clothe.image.url)
			end
			id = clothes.last.id
			response = {'id' => id, 'path' => path}
		end

		render :json => response
	end


    private

    def initialize_clothes(user_id)
		UserWearing::initialized_user_wearing(user_id)
        UserHasClothe::initialized_user_has_clothe(user_id)
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

    def rest_budget(user_id)
        now = Time.current
        rest = 0
        user = User.find(user_id)
        if user then
            lost = 0
            books = Book.where(user: user).where("time > ?", now.beginning_of_month).where("time < ?", now.end_of_month).order('time DESC')
            books.each do |book|
                lost += book.cost
            end
        end

        return user.budget - lost
    end

    def destroy_image
        if @image
        @image.destroy!
        puts 'image destroy'
        end
    end

    def initialize_response
        return response = {
            'error' => false,
            'message' => {},
            'token' => '', 
            'budget' => 0, 
            'rest' => 0
        }
    end

    def no_user(response)
        response['error'] = true
        response['message']['no_user'] = 'ユーザーが存在しません'
        return response
    end
end

class ApiController < ApplicationController
    protect_from_forgery :except => [:create, :login, :image, :register_books, :register_image, :get_image_path, :download_image_by_id, :download_image_by_date, :download_image_all]
    after_action :destroy_image, only: [:image]

    require 'rmagick'

    def register_books
        response = {'token' => 'error', 'budget' => 0, 'rest' => 0}
        token = params[:token]
        items = 'アプリから登録しました'
        costs = params[:costs]
        _times = Time.zone.now

        if ! token.nil? && ! costs.nil?

			user = User.find_by(token: token)

			if ! costs.kind_of?(Array)
				costs = [costs]
			end

            if user && ! costs.empty? then

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
                        books.push(Book.new(item: items, cost: costs[i], user: user, time: _times))
                    end

                    Book.import books
                end
                    puts('success!! commit') # トランザクション処理を確定
                    response = {'token' => user.token, 'budget' => user.budget, 'rest' => rest_budget(user.id)}
                rescue => e
                    puts e # トランザクション処理を戻す
                end

            end
        end

        render :json => response
    end

    def create
        response = {'token' => 'error', 'budget' => 0}
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
            response = {'token' => user.token, 'budget' => rest_budget(user.id)}
        end

        render :json => response
    end

    def login

        response = {'token' => 'error', 'budget' => 0, 'rest' => 0}
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
            if user.token.nil?
                token = Digest::SHA1.hexdigest(params[:email].downcase)
                if user.update(token: token, password: params[:password], password_confirmation: params[:password]) then
					user.token = token
				else
					render :json => response
					return
				end
            end
            response = { 'token' => user.token, 'budget' => user.budget, 'rest' => rest_budget(user.id)}
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
        response = {'token' => 'error', 'path' => 0}
        user = User.find_by(token: token)

        if (user) then
            clothes = Clothe.where(id: UserWearing::get_user_wearing_array(user.id)).order(:priority)
            path=[]
            clothes.each do |clothe|
                path.push('https://' + clothe.image.url)
            end
            if  ! path.empty?
                response = { 'token' => user.token, 'path' => path}
            end
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
		UserWearing::initialized_user_wearing(@user.id)
        UserHasClothe::initialized_user_has_clothe(@user.id)
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
end

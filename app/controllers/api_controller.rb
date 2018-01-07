class ApiController < ApplicationController
    protect_from_forgery :except => [:create, :login, :image, :register_books, :register_image, :get_image_path]
    after_action :destroy_image, only: [:image]

    require 'rmagick'

    def register_books
        response = {'token' => 'error', 'budget' => 0}
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
                    response = {'token' => user.token, 'budget' => rest_budget(user.id)}
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

        response = {'token' => 'error', 'budget' => 0}
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
            if user.token.nil?
                token = Digest::SHA1.hexdigest(params[:email].downcase)
                user.update(token: token, password: params[:password], password_confirmation: params[:password])
                user.token = token
                if !user.save
                    render :json => response
                end
            end
            response = { 'token' => user.token, 'budget' => rest_budget(user.id)}
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
        rest = 0
        user = User.find(user_id)
        if user then
            lost = 0
            books = Book.where(user: user)
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

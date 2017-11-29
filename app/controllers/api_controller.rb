class ApiController < ApplicationController
    protect_from_forgery :except => [:create, :login, :image, :register_books]
    
    require 'rmagick'

    def register_books
        response = {'token' => 'error', 'budget' => 0}
        token = params[:token]
        items = params[:items]
        costs = params[:costs]
        _times = params[:times]

        if token.empty?

            user = User.find_by(token: token)

            if user && ! items.empty? && ! costs.empty? && ! _times.empty? then
                
                if ! items.kind_of?(Array)
                    items = [items]
                end

                if ! costs.kind_of?(Array)
                    costs = [costs]
                end

                if ! _times.kind_of?(Array)
                    _times = [_times]
                end

                begin
                puts('books api start')
                ActiveRecord::Base.transaction do
                    books = [];
                    #経験値の計算

                    puts('coin update start')

                    coin = user.coin + culcurate_coin(_times, costs)
                    user.update_attribute(:coin, coin)

                    puts('coin update')

                    for i in 0..items.size-1 do
                        if costs[i].length >= 10 then
                            next
                        end
                        books.push(Book.new(item: items[i], cost: costs[i], user: user, time: _times[i]))
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
            end
            response = { 'token' => user.token, 'budget' => rest_budget(user.id)}
        end

        render :json => response
    end

    def image
        token= params[:token]
        image = nil
        user = User.find_by(token: token)
        if (user) then
            clothes = Clothe.where(id: UserWearing::get_user_wearing_array(user.id)).order(:priority)
            clothes.each do |clothe|
                path = clothe.image.url
                path = './public' + path

                tmp_image = Magick::Image.from_blob(File.read(path)).first

                if (image.nil?)  
                    image = tmp_image
                else 
                    image = image.composite(tmp_image, 0, 0, Magick::OverCompositeOp)
                end
            end
        else
            image = Magick::Image.from_blob(File.read('./public/error.png')).first
        end

        send_data image.to_blob, type: "image/png", disposition: 'inline'
    end

    private

    def initialize_clothes(user_id)
		user_wearing = UserWearing.new(user_id: user_id, upper_clothes: 1, lower_clothes: 2, sox: 3, front_hair: 4, back_hair: 5, face: 6)
		user_wearing.save
		for num in 1..12 do
			user_has_clothe = UserHasClothe.new(user_id: user_id, clothes_id: num);
			user_has_clothe.save
		end
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
end
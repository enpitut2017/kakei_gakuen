class ClosetsController < ApplicationController
	before_action :logged_in_user, only: [:edit, :update]
	protect_from_forgery :except => [:update]
    #before_action :correct_user, only: [:edit, :update]

    def edit

		#ユーザーが持っている服
		@send_clothes = Clothe::get_user_has_clothes_tag_hash(current_user.id)
		puts('ユーザーが持っている服読み込み完了')
		#ユーザーが着ている服
		@send_user_wearing_clothes = Clothe::get_user_wearing_tag_hash(current_user.id)
		puts('ユーザーが来ている服読み込み完了')
		#全服データ
		@all_clothes = Clothe::get_clothes_tag_has
		puts('全服読み込み完了')
		#ユーザーが服を持っているかどうかの配列
		@user_has_clothes = UserHasClothe::all_clothes_user_has_clothe_array(current_user.id)
		puts('ユーザーが持っている服の配列読み込み完了')

		@tags = Tag::get_tag_key_hash

		@user = current_user
    end

	def update
		if params.blank? then
			redirect_to :action => "edit"
		end
		puts "json get"

		input_params = params
		input_params.delete('controller')
		input_params.delete('action')

		clothes_tag_links_hash = ClothesTagsLink.get_clothes_tags_links_hash_from_clothes(params.values)
		user_wearings = UserWearing::get_user_wearing_tag_hash(current_user.id)
		begin
			ActiveRecord::Base.transaction do
				clothes_tag_links_hash.each do |key, value|
					if user_wearings.has_key?(key) then
						if user_wearings[key].clothe_id != value then
							user_wearings[key].update_attribute(:clothe_id, value)
						end
					else
						user_wearing = UserWearing.new
						user_wearing.user_id = current_user.id
						user_wearing.tag_id = key
						user_wearing.clothe_id = value
						user_wearing.save
					end
				end
			end
			#if Rails.env != 'production' then
				#ローカルの場合、ローカル環境で画像を生成、登録を行う
				image = nil
				clothes = Clothe.where(id: params.values).order(:priority)
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

				puts "画像の保存"
				image.write('public/image.png')
				postdata = {"image" => image.to_blob, "id" => current_user.id}
				url = root_url(only_path: false)
				url = url + "api/register"
				c = HTTPClient.new
				c.connect_timeout = 100
				c.send_timeout    = 100
				c.receive_timeout = 100
				open("public/image.png") do |file|
					postdata = {"image" => file, "id" => current_user.id}
					puts c.post_content(url, postdata)
				end
				image.destroy!
			#end
			flash[:success] = 'お着替えしました'
		rescue => e
			puts e
			flash[:danger] = 'お着替えに失敗しました'
		end
    end


	def buy
		error = false
		#知らないuser, clotheがきたらrescue
		begin
			#受け取った、購入したい情報をパース
			json_request = JSON.parse(request.body.read)
			buy_id = json_request["buy_id"]
			user_id = json_request["user_id"]

			user = User.find_by(id: user_id)
			cloth = Clothe.find_by(id: buy_id)
			puts "successfully received"
		rescue
			puts "failed to receive json data"
		end


		#数々のエラー処理
		#存在しない、ユーザもしくは服が送られてきたら
		if !(user || cloth)
			error = true
			puts("購入しようとした服は存在しないか、ユーザが存在しません")
		end
		#高い商品を購入しようとしたら
		if user.coin < cloth.price
			error = true
			puts("高杉新作")
		end

		#エラーが出たらresult = 0 elseはresult = 1をsend
		if error
			puts "something has failed to update user data"
			result = {'result' => 0}
		else
			if !UserHasClothe.find_by(clothes_id: cloth.id)
				user.update_attribute(:coin, user.coin - cloth.price)	#支払い
				UserHasClothe.create(user_id: user.id, clothes_id: cloth.id)	#ユーザの持ってる服追加
				puts "服の新規購入"
			else
				puts "既に持ってるので着せ替えだけしました"
			end

			user_wearings = UserWearing.find_by(user_id: user_id)		#ユーザの現在きている服取得
			user_wearings_hash = user_wearings.attributes		#ハッシュ化
			bought_cloth_tag = Tag.find_by(id: ClothesTagsLink.find_by(clothes_id: buy_id)).attributes["tag"]	#ユーザの買った服のタグハッシュで取得

			user_wearings_hash[bought_cloth_tag] = buy_id
			user_wearings.update_attributes(user_wearings_hash)		#ユーザの服情報更新
			user_wearings = UserWearing.find_by(user_id: user_id)	#ユーザの現在きている服取得

			result = {'result' => 1}
			puts('successfully updated user data')
		end

		#viewにjsonを送信
		respond_to do |format|
			format.html{redirect_to action: :edit}
			format.json{render :json => @result}
		end
	end


	private

	def logged_in_user
		unless logged_in?
			store_location
			flash[:danger] = "ログインしてください."
			redirect_to login_path
		end
	end

	def correct_user
      @user = User.find(params[:id])
      redirect_to user_path(current_user) unless @user == current_user
    end
end

class ClosetsController < ApplicationController
	before_action :logged_in_user, only: [:edit, :update]
    #before_action :correct_user, only: [:edit, :update]

    def edit

		#@user_clothesがユーザーが今装備しているもの、@send_clothesがユーザーが持っている装備が入っているものです

		#userのが現在設定している装備
		@user_clothes = UserWearing.find_by(user_id: current_user.id)

		#userが現在設定している装備を取得

		user_wearing_clothes = Clothe.where(id: [@user_clothes.upper_clothes, @user_clothes.lower_clothes, @user_clothes.sox, @user_clothes.front_hair, @user_clothes.back_hair, @user_clothes.face])
		keys_user_wearing_clothes = Clothe.where(id: [@user_clothes.upper_clothes, @user_clothes.lower_clothes, @user_clothes.sox, @user_clothes.front_hair, @user_clothes.back_hair, @user_clothes.face]).pluck(:id)
		user_wearing_clothes = Hash[keys_user_wearing_clothes.collect.zip(user_wearing_clothes)]
		user_wearing_clothes_tags_links = ClothesTagsLink.where(clothes_id: keys_user_wearing_clothes)

		#userが所有している装備とそのタグ
	    user_has_clothes = UserHasClothe.where(user_id: current_user.id).pluck(:clothes_id)
	    clothes_tags_links = ClothesTagsLink.where(clothes_id: user_has_clothes)

		#装備データ及びtagデータ
		clothes = Clothe.where(id: user_has_clothes)
		tags = Tag.all

		#clothesを使いやすいようにする
		keys_clothes = Clothe.where(id: user_has_clothes).pluck(:id)
		clothes =  Hash[keys_clothes.collect.zip(clothes)]

		#tagsを使いやすいようにする
		keys_tags = Tag.pluck(:id)
		tags = Hash[keys_tags.collect.zip(tags)]


		#テンプレートに送るデータの作成
		@send_clothes = Hash.new
		clothes_tags_links.each do |clothes_tags_link|
			if @send_clothes.has_key?(tags[clothes_tags_link.tag_id].tag) then
				@send_clothes[tags[clothes_tags_link.tag_id].tag].push(clothes[clothes_tags_link.clothes_id])
			else
				@send_clothes[tags[clothes_tags_link.tag_id].tag] = Array.new
				@send_clothes[tags[clothes_tags_link.tag_id].tag].push(clothes[clothes_tags_link.clothes_id])
			end
		end

		@send_user_wearing_clothes = Hash.new
		user_wearing_clothes_tags_links.each do |user_wearing_clothes_tags_link|
			if @send_user_wearing_clothes.has_key?(tags[user_wearing_clothes_tags_link.tag_id].tag) then
				@send_user_wearing_clothes[tags[user_wearing_clothes_tags_link.tag_id].tag].push(user_wearing_clothes[user_wearing_clothes_tags_link.clothes_id])
			else
				@send_user_wearing_clothes[tags[user_wearing_clothes_tags_link.tag_id].tag] = Array.new
				@send_user_wearing_clothes[tags[user_wearing_clothes_tags_link.tag_id].tag].push(user_wearing_clothes[user_wearing_clothes_tags_link.clothes_id])
			end
		end

    end

	def update
		if params.blank? then
			redirect_to :action => "edit"
		end
		puts "json get"
		user_wearing = UserWearing.find_by(user_id: current_user.id)

		input_params = params
		input_params.delete('controller')
		input_params.delete('action')

		clothes_tag_links_hash = ClothesTagsLink.get_clothes_tags_links_hash_from_clothes(params.values)

		begin
			clothes_tag_links_hash.each do |key, value|
				user_wearing = UserWearing.find_by(user_id: current_user.id, tag_id: key)
				if user_wearing then
					user_wearing.update_attribute(:clothe_id, value)
				else
					user_wearing = UserWearing.new
					user_wearing.user_id = current_user.id
					user_wearing.tag_id = key
					user_wearing.clothe_id = value
					user_wearing.save
				end
			end
			flash[:success] = 'お着替えしました'
		rescue
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

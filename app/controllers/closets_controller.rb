class ClosetsController < ApplicationController
	before_action :logged_in_user, only: [:edit, :update]
    #before_action :correct_user, only: [:edit, :update]

    def edit

		#ユーザーが持っている服
		@send_clothes = Clothe::get_user_has_clothes_tag_hash(current_user.id)

		#ユーザーが着ている服
		@send_user_wearing_clothes = Clothe::get_user_wearing_tag_hash(current_user.id)

		#全服データ
		@all_clothes = Clothe::get_clothes_tag_has

    end

	def update
		if params.blank? then
			redirect_to :action => "edit"
		end
		puts "json get"
		user_wearing = UserWearing.find_by(user_id: current_user.id)

		if user_wearing.update(upper_clothes: params["upper_clothes"], lower_clothes: params["lower_clothes"], sox: params["sox"], back_hair: params["back_hair"], front_hair: params["front_hair"], face: params["face"]) then
			redirect_to :action => "edit"
		else
			redirect_to :action => "edit"
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

			# user_wearings_hash.map { |key, value|		#購入した服と同じ部分を着せ替える
			# 	if key == bought_cloth_tag
			# 		user_wearings_hash[key] = buy_id
			# 	end
			# }
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

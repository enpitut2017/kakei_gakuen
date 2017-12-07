class ClosetsController < ApplicationController
	before_action :logged_in_user, only: [:edit, :update]
    #before_action :correct_user, only: [:edit, :update]

    def edit

		#ユーザー情報
		@user = current_user
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
    end

	def update
		if params.blank? then
			redirect_to :action => "edit"
		end
		puts "json get"

		input_params = params
		input_params.delete('controller')
		input_params.delete('action')

		tag_id = Tag.where(tag: input_params.keys).pluck(:id)
		tag_value = input_params.values
		tags = Hash[tag_id.collect.zip(tag_value)]

		begin
			tags.each do |key, value|
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

		redirect_to :action => "edit"

    end


	def buy
		#error = false
		#知らないuser, clotheがきたらrescue
		begin

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
				raise
			end

			error = false
			begin
				if !(user || cloth)
					error = true
					puts("購入しようとした服は存在しないか、ユーザが存在しません")
				end
				#高い商品を購入しようとしたら
				if user.coin < cloth.price
					error = true
					puts("高杉新作")
				end
			rescue
				puts "null pointer Exception."
				raise
			end

			if error
				puts "purchase failed."
				@result = {'result' => 0}
			else
				begin
					if !UserHasClothe.find_by(clothes_id: cloth.id)
						user.update_attribute(:coin, user.coin - cloth.price)	#支払い
						UserHasClothe.create(user_id: user.id, clothes_id: cloth.id)	#ユーザの持ってる服追加
						puts "服の新規購入"
					else
						puts "既に持ってるので着せ替えだけしました"
					end

					user_wearings = UserWearing.where(user_id: user_id)		#ユーザの現在きている服全部を取得

					#ユーザの買った服のタグを取得
					bought_cloth_tag_id = ClothesTagsLink.find_by(clothes_id: buy_id).tag_id

					#nilなら購入したい服のタグを所持していないので新規作成
					#タグを所持していたら、clothe_idを書き換え
					change_cloth_data = user_wearings.find_by(tag_id: bought_cloth_tag_id)

					if change_cloth_data.nil?
						UserWearing.create(user_id: user.id, tag_id: bought_cloth_tag_id, clothe_id: buy_id)
					else
						change_cloth_data.update_attribute(:clothe_id, buy_id)		#ユーザの服情報更新
					end

					@result = {'result' => 1}
					puts('successfully updated user data')
				rescue
					raise
				end
			end

			#viewにjsonを送信
			respond_to do |format|
				format.html{redirect_to action: :edit}
				format.json{render :json => @result}
			end

		rescue
			puts "something failed. check error message"
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

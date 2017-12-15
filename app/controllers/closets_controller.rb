class ClosetsController < ApplicationController
	before_action :logged_in_user, only: [:edit, :update]
	protect_from_forgery :except => [:update, :buy]
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

			#画像の登録 ローカル環境の場合はすべてローカルのみで行う
			#本番環境の場合idcfサーバーを経由して登録
			#サーバーの問題があるので以下の方法はやめます
=begin
			if Rails.env != 'production' then
				#ローカルの場合、ローカル環境で画像の生成のみを行う
				#/public/image.pngに生成される
				#テストで生成する場合、コメントアウトを外す。日本語ファイル不可
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
				image.destroy!

			else
				clothes = Clothe.where(id: params.values).order(:priority)
				image_path = []
				clothes.each do |clothe|
					image_path.push('https://'+clothe.image.to_s)
				end

				postdata = {"url[]" => image_path, "id" => current_user.id}
				url = "https://kakeigakuen-staging.xyz/api/image/"
				c = HTTPClient.new
				c.connect_timeout = 100
				c.send_timeout    = 100
				c.receive_timeout = 100

				puts c.post_content(url, postdata)
			end
=end
			flash[:success] = 'お着替えしました'
		rescue => e
			puts e
			flash[:danger] = 'お着替えに失敗しました'
		end		
		redirect_to :action => "edit"

    end


	def buy
		#知らないuser, clotheがきたらrescue
		@result ={
			'user_id' => 0,
			'clothe_id' => 0,
			'result' => 0,
		}
		begin
			begin
				#受け取った、購入したい情報をパース
				input_params = params
				#json_request = JSON.parse(request.body.read)
				buy_id = input_params["buy_id"]
				user_id = input_params["user_id"]

				user = User.find_by(id: user_id)
				cloth = Clothe.find_by(id: buy_id)

				@result['user_id'] = user_id
				@result['clothe_id'] = buy_id

				puts "successfully received"
			rescue
				puts "failed to receive json data"
				flash[:danger] = "服の読み込みかユーザーの読み込みに失敗しました user_id : #{user_id} buy_id: #{buy_id}"
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
				flash[:danger] = "ユーザーか服が見つかりませんでした"
				raise
			end

			if error
				puts "purchase failed."
				@result['result'] = 0
			else
				begin
					if ! UserHasClothe::user_has_clothe?(user.id, cloth.id)
						user.update_attribute(:coin, user.coin - cloth.price)	#支払い
						UserHasClothe.create(user_id: user.id, clothes_id: cloth.id)	#ユーザの持ってる服追加
						flash[:success] = "服が購入できました"
						puts "服の新規購入"
					else
						flash[:danger] = "もう服を持っています"
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

					@result['result'] = 1
					puts('successfully updated user data')
				rescue
					flash[:danger] = "服が購入できませんでした"
					raise
				end
			end

		rescue
			puts "something failed. check error message"
		end

		#viewにjsonを送信
		render :json => @result
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

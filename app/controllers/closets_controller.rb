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
    end

	private
		def logged_in_user
			unless logged_in?
				store_location
				flash[:danger] = "Please log in."
				redirect_to login_path
			end
		end

		def correct_user
      @user = User.find(params[:id])
      redirect_to user_path(current_user) unless @user == current_user
    end
end

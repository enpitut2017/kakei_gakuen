class ClosetsController < ApplicationController
	before_action :logged_in_user, only: [:edit, :update]
  	before_action :correct_user, only: [:edit, :update]

    def edit

		#@user_clothesがユーザーが今装備しているもの、@send_clothesがユーザーが持っている装備が入っているものです

		#userのが現在設定している装備
        @user_clothes = UserWearing.find_by(user_id: current_user.id)

		#userが所有している装備とそのタグ
        user_has_clothes = UserHasClothe.where(user_id: current_user.id).pluck(:clothes_id)
        clothes_tags_links = ClothesTagsLink.where(clothes_id: user_has_clothes)

		#装備データ及びtagデータ
		clothes = Clothe.where(id: user_has_clothes)
		tags = Tag.all

		#clothesを使いやすいようにする
		keys = Clothe.where(id: user_has_clothes).pluck(:id)
		clothes =  Hash[keys.collect.zip(clothes)]

		#テンプレートに送るデータの作成
		@send_clothes = Hash.new
		clothes_tags_links.each do |clothes_tags_link|
			if @send_clothes.has_key?(tags[clothes_tags_link.tag_id].tag) then
				@send_clothes[tags[clothes_tags_link.tag_id].tag].push(clothes[clothes_tags_link.clothes_id])
			else
				@send_clothes[tags[clothes_tags_link.tag_id].tag] = array()
				@send_clothes[tags[clothes_tags_link.tag_id].tag].push(clothes[clothes_tags_link.clothes_id])
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
      		@user = User.find(params[:id]))
      		redirect_to user_path(current_user) unless @user == current_user
    	end
end

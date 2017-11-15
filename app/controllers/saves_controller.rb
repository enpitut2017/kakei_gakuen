class SavesController < ApplicationController
    protect_from_forgery :except => [:create, :update]

    def index
        @clothes = Clothe.page(params[:page]).per(10).order(:id)
        clothes_id = Clothe.page(params[:page]).per(10).order(:id).pluck(:id)

        tags = Tag.all;
        keys_tags = Tag.pluck(:id)
		@send_tags = Hash[keys_tags.collect.zip(tags)]

        keys_send_clothe_tag_link = ClothesTagsLink.where(clothes_id: clothes_id).pluck(:clothes_id)
        @send_clothe_tag_link = ClothesTagsLink.where(clothes_id: clothes_id)
        @send_clothe_tag_link =  Hash[keys_send_clothe_tag_link.collect.zip(@send_clothe_tag_link)]
    end

    def edit
        tags = Tag.all;
        @send_tags = tags.map{|tag| [tag.id, tag.attributes]}
        @send_clothe = Clothe.find(params[:id])
        @send_clothe_tag_link = ClothesTagsLink.find_by(clothes_id: @send_clothe.id)
    end

    def new
        tags = Tag.all
        @send_tags = tags.map{|tag| [tag.id, tag.attributes]}
    end

    def create
        puts("clothes data generate start")
        clothe = Clothe.new
        clothe.name = params[:clothe_name]
        clothe.image = params[:clothe_image]
        begin
            ActiveRecord::Base.transaction do
                #ここに処理を書く
                clothe.save
                send_clotes_tags_link = ClothesTagsLink.new
                send_clotes_tags_link.tag_id = params[:tag_id]
                last = Clothe.last
                send_clotes_tags_link.clothes_id = last.id
                send_clotes_tags_link.save
            end
            puts('success!! commit') # トランザクション処理を確定
        rescue => e
            puts('error!! rollback') # トランザクション処理を戻す
        end
        puts("clothes data generate end")
    end

    def update
        puts("clothes data generate start")
        clothe = Clothe.find(params[:id])
        begin
            ActiveRecord::Base.transaction do
                #ここに処理を書く
                clothe.update(name: params[:clothe_name], image:params[:clothe_image])
                send_clotes_tags_link = ClothesTagsLink.find_by(clothes_id: params[:id])
                send_clotes_tags_link.update(tag_id: params[:tag_id])
            end
            puts('success!! commit') # トランザクション処理を確定
        rescue => e
            puts('error!! rollback') # トランザクション処理を戻す
        end
        puts("clothes data generate end")
        redirect_to action: 'edit', id: params[:id]
    end
end
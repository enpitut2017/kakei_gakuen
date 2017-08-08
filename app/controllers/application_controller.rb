require "date"
require 'time'
class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    include SessionsHelper

    #httpエラーの処理
    rescue_from ActionController::ActionControllerError, with: :error_403
    rescue_from ActionController::ActionControllerError, with: :error_403
    rescue_from ActiveRecord::RecordNotFound, :with => :error_404
    rescue_from ActionController::RoutingError, :with => :error_404
    rescue_from Exception, with: :error_500

    #経験値計算
    def culcurate_exp(items)
        defalt_exp = 10
        times = Array.new
        d = Time.parse(Date.today.strftime("%Y-%m-%d")).to_i
        items.each do |item|
            times.push(((d-Time.parse(item).to_i)/100)/864)
        end
        times.each do |time|
            defalt_exp -= time
            puts "now score : #{defalt_exp}"
        end
        if defalt_exp < 1 then
            defalt_exp = 1
        end
        return defalt_exp
    end

    #レベル計算
    def level_culcurate
        exp = current_user.exp
        if exp == nil then
            exp = 0
        end
        #debugger

        level = 0
        levelup_table = [0, 10, 20]
        size = levelup_table.size
        tmpexp = exp
        while (level < size) and ((tmpexp -= levelup_table[level]) >= 0) do
            level += 1
        end
        return level
    end

    #画像パス生成
    def image_path(level)
        case level
        when 1 then
            path = '/assets/sotai_low.png'
        when 2 then
            path = '/assets/sotai_evo1.png'
        when 3 then
            path = '/assets/sotai_evo2.png'
        else
            path = '/assets/sotai_low.png'
        end
        return path
    end

    #403エラー
    def error_403
        return render :template => '/error/403', :layout => true, :status => 404
    end

    #404エラー
    def error_404
        return render :template => '/error/404', :layout => true, :status => 404
    end

    #500エラー
    def error_500
        return render :template => '/error/500', :layout => true, :status => 500
    end
end

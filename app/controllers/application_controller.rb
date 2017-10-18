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
        return render :template => '/error/error_403', :layout => true, :status => 403
    end

    #404エラー
    def error_404
        return render :template => '/error/error_404', :layout => true, :status => 404
    end

    #500エラー
    def error_500
        return render :template => '/error/error_500', :layout => true, :status => 500
    end
end

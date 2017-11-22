require "date"
require 'time'
class ApplicationController < ActionController::Base
    add_flash_types :success, :info, :warning, :danger
    protect_from_forgery with: :null_session
    include SessionsHelper
    include ManagersHelper

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
    def error_403(e = nil)
        logger.info "Rendering 403 with exception: #{e.message}" if e
        render template: "error/error_403",:status => 403
    end

    #404エラー
    def error_404(e = nil)
        logger.error "Rendering 404 with exception: #{e.message}" if e
        render template: "error/error_404",:status => 404
    end

    #500エラー
    def error_500(e = nil)
        logger.error "Rendering 500 with exception: #{e.message}" if e
        render template: "error/error_500",:status => 500
    end
end

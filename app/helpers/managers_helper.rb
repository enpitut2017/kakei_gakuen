module ManagersHelper
    # 渡されたユーザーでログインする
    def log_in_manager(manager)
        session[:manager_id] = manager.id
    end

    def current_manager
        if (manager_id = session[:manager_id])
            @current_manger ||= Manager.find_by(id: manger_id)
        elsif (manager_id = cookies.signed[:manager_id])
            manager = Manager.find_by(id: manger_id)
            if manager && manager.authenticated?(cookies[:remember_token])
                log_in manager
                @current_manger = manager
            end
        end
    end

    def logged_in_manager?
        !current_manager.nil?
    end

    def log_out_manager
        session.delete(:manager_id)
        @current_manager = nil
    end
end

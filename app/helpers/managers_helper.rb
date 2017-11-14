module ManagersHelper
    def log_in(manager)
        session[:manager_id] = manager.id
    end
end

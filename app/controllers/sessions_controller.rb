class SessionsController < ApplicationController
    def new
    end

    def create
        user = User.find_by(email: params[:session][:email].downcase)
        if user && user.authenticate(params[:session][:password])
            log_in user
            redirect_to user
        else
            flash.now[:danger] = 'Invalid email/password combination'
            render 'new'
        end
    end

    def destroy
        log_out
        puts "&&&&&&&&&&&&&&&&&&&&&&&&&"
        puts logged_in?
        puts "&&&&&&&&&&&&&&&&&&&&&&&&&"
        redirect_to signup_path
    end
end

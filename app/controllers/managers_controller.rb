class ManagersController < ApplicationController
  def new
  end

  def create
      manager = Manager.find_by(name: params[:manager][:name])
      if manager && manager.authenticate(params[:manager][:password])
          log_in_manager manager
          redirect_to root_path     #ここはまだ書き換えていないので途中(本来は管理者画面(データ全部登録できる画面)に飛ぶ)
      else
          flash.now[:danger] = 'Invalid email/password combination'
          redirect_to managers_login_path
      end
  end

  def destroy
      log_out_manager
      redirect_to root_path
  end
end

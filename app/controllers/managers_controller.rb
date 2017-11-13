class ManagersController < ApplicationController
  def new
  end

  def create
      manager = Manager.find_by(name: params[:manager][:name])
      if manager && manager.authenticate(params[:manager][:password])
          log_in manager
          redirect_to root_path     #ここはまだ書き換えていないので途中(本来は管理者画面(データ全部登録できる画面)に飛ぶ)
      else
          flash.now[:danger] = 'Invalid name/password combination'
          render 'new'
      end
  end

  def destroy
      log_out
      redirect_to root_path
  end


end

class ComicsController < ApplicationController
  def index
  end
  def episode
    @episode = params[:id]
  end
end

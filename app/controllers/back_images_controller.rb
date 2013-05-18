class BackImagesController < ApplicationController
  before_filter :required_login

  def new
  end

  def create
    BackImage.all.each {|bi| bi.destroy}
    back_image = BackImage.create!(params[:back_image].permit!)
    redirect_to manage_path
  end
end

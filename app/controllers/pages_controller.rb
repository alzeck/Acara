class PagesController < ApplicationController
  def home
  end

  def search
    @search = params[:q]
  end
end

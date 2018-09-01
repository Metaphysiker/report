class IonicController < ApplicationController

 protect_from_forgery unless: -> { request.format.json? }

  def ionic
    @pages = AlchemyPage.where(page_layout: "article")

    respond_to do |format|
      format.json
      #format.json { render json: @pages }
     end
  end

end

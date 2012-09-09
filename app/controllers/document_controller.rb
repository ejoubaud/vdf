class DocumentController < ApplicationController
  
  def show
    @document = Document.find(params[:name])
  end

  
end

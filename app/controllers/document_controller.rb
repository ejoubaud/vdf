class DocumentController < ApplicationController
  
  def show
    (@doc = Document.sheet(params[:name])) or not_found
  end
  
end
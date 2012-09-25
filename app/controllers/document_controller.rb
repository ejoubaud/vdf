class DocumentController < ApplicationController
  
  def show
    (@doc = Document.sheet(params[:name])) or not_found
  end

  def new
    @doc = Document.new
  end

  def create
  end

end
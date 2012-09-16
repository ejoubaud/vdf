class DocumentController < ApplicationController
  
  def show
    docs = Document.where({ name: params[:name], active: true })
    if docs.length == 1
      @doc = docs[0]
    else
      not_found
    end
  end
  
end

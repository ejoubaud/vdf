class DocumentController < ApplicationController
  
  def show
    docus = Document.where({ name: params[:name], active: true })
    if docus.length == 1
      @docu = docus[0]
    else
      not_found
    end
  end
  
end

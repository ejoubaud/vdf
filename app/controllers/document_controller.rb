# encoding = utf-8

class DocumentController < ApplicationController
  
  def show
    (@doc = Document.sheet(params[:name])) or not_found
  end

  def new
    @doc = create_doc_form
    @stamps = Stamp.all
  end

  def create
    debugger
    @doc = Document.new(params[:doc])
    @doc.active = true
    if @doc.save
      flash[:notice] = "Nouveau documentaire créé."
      redirect_to action: :show, name: @doc.name
    else
      render action: :new
    end
  end

private

  def create_doc_form
    doc = Document.new
    3.times { doc.checks.build }
    2.times { doc.reviews.build }
    2.times { doc.themes.build }
    doc.themes.each do |theme|
      2.times { theme.links.build }
    end
    doc
  end

end
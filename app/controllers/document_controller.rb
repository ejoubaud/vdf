# encoding = utf-8

class DocumentController < ApplicationController

  def show
    (@doc = Document.sheet(params[:name])) or not_found
  end

  def new
    @doc = create_doc_new_form
    @stamps = Stamp.all
  end

  def create
    @doc = Document.new(params[:doc])
    @doc.active = true
    if @doc.save
      flash[:notice] = "Nouveau documentaire créé."
      redirect_to action: :show, name: @doc.name
    else
      render action: :new
    end
  end

  def list
    docs = Document.where(active: true).order(:title)
    @docs_by_letter = sort_by_title_first_letter docs
  end

  def edit
    (@doc = Document.sheet(params[:name])) or not_found
  end

  def update
    @doc = Document.find(params[:id])
    @doc.update_attributes(params[:doc])
    if @doc.save
      flash[:notice] = "Modifications enregistrées."
    end
    render action: :edit
  end

private

  def create_doc_new_form
    doc = Document.new
    3.times { doc.checks.build }
    2.times { doc.reviews.build }
    2.times { doc.themes.build }
    doc.themes.each do |theme|
      2.times { theme.options.build }
    end
    doc
  end

  def sort_by_title_first_letter documents
    documents.reduce({}) do |by_letter, doc|
      by_letter[doc.title[0].upcase] ||= [];
      by_letter[doc.title[0].upcase] << doc;
      by_letter
    end
  end

end
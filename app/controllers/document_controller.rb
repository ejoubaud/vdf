# encoding = utf-8

class DocumentController < ApplicationController

  #before_filter :authenticate_user!, only: [ :new, :create, :edit, :update, :list_edit ]
  load_and_authorize_resource

  def show
    (@doc = Document.sheet(params[:name])) or not_found
    #authorize! :read, @doc
  end

  def list
    @docs   = Document.where(active: true).order(:title)
    @action = 'show'
    @title  = 'Documentaires'
  end

  # Renders the draft versions list for logged-in editors
  def edit_list
    # TODO Change to active: false when draft/active and permissions are implemented
    @docs   = Document.where(active: true).order(:title)
    @action = 'edit'
    @title  = 'Contribution'
    render 'list'
  end

  def new
    @doc = create_doc_new_form
    @stamps = Stamp.all
  end

  def create
    @doc = Document.new(params[:doc])
    @doc.name   = params[:name]
    @doc.active = true
    @doc.assign_author! current_user
    if @doc.save
      flash[:notice] = "Nouveau documentaire créé."
      redirect_to action: :show, name: @doc.name
    else
      render action: :new
    end
  end

  def edit
    (@doc = Document.sheet(params[:name])) or not_found
  end

  def update
    @doc = Document.find(params[:id])
    @doc.assign_attributes(params[:doc])
    @doc.assign_author! current_user
    if @doc.save
      flash[:notice] = "Modifications enregistrées."
      redirect_to action: :show, name: @doc.name
    else
      render action: :edit
    end
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

end
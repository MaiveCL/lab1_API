class ProductsController < ApplicationController
  # remplace la répétition par un before_action
  # before_action :authenticate_user!, only: %i[ create edit update destroy ]
  # seulement le moment de confirmer la création était bloqué (la page affichait)
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :set_product, only: %i[ edit update destroy ]

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
    @product.build_image_description # pour l’association de masse # fields_for
  end

  def create
    @product = current_user.products.build(product_params)

    if @product.save
      redirect_to @product
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @product = Product.find(params[:id])
    # remplace la répétition par un before_action
    @product.build_image_description unless @product.image_description
  end

  def update
    # Vérifie si le FORMULAIRE contient une nouvelle image pour le produit
    
    if params[:product][:image_description_attributes]&.[](:image).present?
    # if params[:product][:image_description_attributes][:image].present?
    # if params[:product][:featured_image].present?
      # Alors Si le produit avait déjà une image attachée, on la supprime
      # @product.featured_image.purge if @product.featured_image.attached?
      @product.image_description.image.purge if @product.image_description&.image&.attached?
      # purge supprime tout : l'attachement, blob + fichier réel 
        # sauf si le fichier est utilisé ailleurs, il supprime juste l'attachement car BLOB a des protections
  end

    # Met à jour le produit avec tous les paramètres envoyés par le formulaire
    if @product.update(product_params)
      redirect_to @product
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path
  end

  # protection contre les envoies indésirables pour create et update
  private
    def product_params
      # params.expect(product: [ :name, :description, :featured_image ]) # anceinne version
      params.expect(product: [:name, :description, :inventory_count, image_description_attributes: [:id, :image]])

      # params.require(:product).permit(:name, :description, image_description_attributes: [:id, :image])
    end

    def set_product
      @product = current_user.products.find(params[:id])
    end
end
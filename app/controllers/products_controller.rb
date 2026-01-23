class ProductsController < ApplicationController

  # remplace la répétition par un before_action
  # before_action :authenticate_user!, only: %i[ create edit update destroy ]
    # seulement le moment de confirmer la création était bloqué (la page affichait)
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :set_product, only: %i[ show edit update destroy update ]
  before_action :authorize_user!, only: %i[ edit update destroy ]

  def index
    @products = Product.all
  end

  def show
    # @product = Product.find(params[:id])
    # remplace la répétition par un before_action
  end

  def new
    @product = Product.new
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
  end

  def update
    # Vérifie si le FORMULAIRE contient une nouvelle image pour le produit
    if params[:product][:featured_image].present?
      # Alors Si le produit avait déjà une image attachée, on la supprime
      @product.featured_image.purge if @product.featured_image.attached?
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
      params.expect(product: [ :name, :description, :featured_image ])
    end

    def set_product
      @product = Product.find(params[:id])
    end

    def authorize_user!
    unless @product.productable == current_user
      redirect_to products_path, alert: "Ce produit ne vous appartient pas!"
    end
end

end
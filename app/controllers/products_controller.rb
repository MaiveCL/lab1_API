class ProductsController < ApplicationController

  # remplace la répétition par un before_action
  # before_action :authenticate_user!, only: %i[ create edit update destroy ]
    # seulement le moment de confirmer la création était bloqué (la page affichait)
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :set_product, only: %i[ show edit update destroy ]

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
    @product = Product.new(product_params)
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
    @product = Product.find(params[:id])
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
      params.expect(product: [ :name, :description ])
    end

    def set_product
      @product = Product.find(params[:id])
    end

end

# 10.6.1. Extracting Partials
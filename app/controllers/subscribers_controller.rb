class SubscribersController < ApplicationController
  before_action :set_product

  def create
    @product.subscribers.where(subscriber_params).first_or_create

    respond_to do |format|
      format.html { redirect_to @product, notice: "You are now subscribed." }
      format.json { render json: @subscriber, status: :created }
    end
  end

  private
    def set_product
      @product = Product.find(params[:product_id])
    end

    def subscriber_params
      params.expect(subscriber: [ :email ])
    end
end

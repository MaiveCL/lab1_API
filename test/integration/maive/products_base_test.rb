require "test_helper"

class ProductsBaseTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one_user)
    @other_user = users(:two_user)

    @product = products(:one_product)
    @product.description = "Description du produit"
    @product.save!
    @empty_product = products(:no_stock)

    # Images polymorphiques
    @image = image_descriptions(:one_image)

    @valid_product_params = {
      name: "Produit valide",
      description: "Description via ActionText",
      inventory_count: 10,
      productable_type: "User",
      productable_id: @user.id
    }

    @invalid_product_name = {
      name: "",
      description: "Description",
      inventory_count: 10
    }
  end
end

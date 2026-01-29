require "test_helper"
require_relative "products_base_test"

class ProductsCreateFailTest < ProductsBaseTest
  test "POST /products.json fails without authentication" do
    assert_no_difference("Product.count") do
      post products_path, params: { product: @valid_product_params }, as: :json
    end

    assert_response :unauthorized
  end

  test "POST /products.json fails with invalid params" do
    sign_in @user

    assert_no_difference("Product.count") do
        post products_path, params: { product: @invalid_product_name }, as: :json
    end

    assert_response :unprocessable_entity
    end
end

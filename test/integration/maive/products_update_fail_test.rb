require "test_helper"
require_relative "products_base_test"

class ProductsUpdateFailTest < ProductsBaseTest
  test "PATCH /products/:id.json fails without authentication" do
    assert_no_changes -> { @product.reload.name } do
      patch product_path(@product), params: { product: { name: "Fail" } }, as: :json
    end

    assert_response :unauthorized
  end

  test "PATCH /products/:id.json fails with invalid params" do
    sign_in @user

    assert_no_changes -> { @product.reload.name } do
      patch product_path(@product), params: { product: { name: "" } }, as: :json
    end

    assert_response :unprocessable_entity
  end
end

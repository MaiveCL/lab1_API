require "test_helper"
require_relative "products_base_test"

class ProductsDeleteFailTest < ProductsBaseTest
  test "DELETE /products/:id.json fails without authentication" do
    assert_no_difference("Product.count") do
      delete product_path(@product), as: :json
    end

    assert_response :unauthorized
  end
end

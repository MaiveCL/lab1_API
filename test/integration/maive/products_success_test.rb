require "test_helper"
require_relative "products_base_test"

class ProductsSuccessTest < ProductsBaseTest
  test "GET /products.json returns exactly the products from fixtures" do
    get products_path, as: :json
    assert_response :success

    # 1) JSON valide
    assert_nothing_raised { JSON.parse(response.body) }
    data = JSON.parse(response.body)

    # 2) Même nombre d’éléments que dans la base
    assert_equal Product.count, data.length

    # 3) Le produit de la fixture est présent
    json_product = data.find { |p| p["id"] == @product.id }
    assert_not_nil json_product

    # 4) Les champs correspondent exactement
    assert_equal @product.name, json_product["name"]
    assert_equal @product.inventory_count, json_product["inventory_count"]
  end

  test "GET /products/:id.json returns the exact product from fixture" do
    get product_path(@product), as: :json
    assert_response :success

    # 1) JSON valide
    assert_nothing_raised { JSON.parse(response.body) }
    data = JSON.parse(response.body)

    # 2) Le bon enregistrement est retourné
    assert_equal @product.id, data["id"]

    # 3) Les champs correspondent à la fixture
    assert_equal @product.name, data["name"]
    assert_equal @product.inventory_count, data["inventory_count"]
  end

  test "POST /products.json creates a product" do
    sign_in @user

    assert_difference("Product.count", +1) do
      post products_path, params: { product: @valid_product_params }, as: :json
    end

    assert_response :created
    data = JSON.parse(response.body)
    assert_equal @valid_product_params[:name], data["name"]
    assert_equal @valid_product_params[:inventory_count], data["inventory_count"]
  end

  test "POST /products.json creates a product with description" do
    post products_path, params: {
      product: {
        name: "Produit avec description",
        inventory_count: 5,
        productable_type: "User",
        productable_id: @user.id
      }
    }, as: :json

    product = Product.last
    product.description = "Une belle description"
    product.save!

    assert_equal "Une belle description", product.description.to_plain_text
  end

  test "PATCH /products/:id.json updates a product" do
    sign_in @user

    patch product_path(@product), params: { product: { name: "Nom Mis à Jour" } }, as: :json
    assert_response :success

    data = JSON.parse(response.body)
    assert_equal "Nom Mis à Jour", data["name"]
    assert_equal "Nom Mis à Jour", @product.reload.name
  end

  test "DELETE /products/:id.json destroys a product" do
    sign_in @user

    assert_difference("Product.count", -1) do
      delete product_path(@product), as: :json
    end

    assert_response :no_content
  end
end

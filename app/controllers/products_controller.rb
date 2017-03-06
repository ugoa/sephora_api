class ProductsController < ApplicationController

  def index
    @products = Product.page(1).per(10)

    render json: @products, status: :ok
  end

  def show

  end
end

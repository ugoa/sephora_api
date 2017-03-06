class ProductsController < ApplicationController

  def index
    @products = Product.page(1).per(10)

    render json: @products, status: :ok
  end

  def show
    @product = Product.find_by(id: params[:id])

    render json: @product, status: :ok
  end
end

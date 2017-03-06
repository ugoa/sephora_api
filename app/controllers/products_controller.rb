class ProductsController < ApplicationController

  def index
    @products = Product.page(1).per(10)

    render json: @products, status: :ok
  end

  def show
    @product = Product.find_by(id: params[:id])

    if @product
      render json: @product, status: :ok
    else
      render json: {}, status: :not_found
    end
  end
end

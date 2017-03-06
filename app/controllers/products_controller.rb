class ProductsController < ApplicationController

  def index
    @products = Product.all

    render json: @products, status: :ok
  end

  def show

  end
end

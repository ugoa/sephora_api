class ProductsController < ApplicationController

  def index
    query = ProductQueryService.new(filter_params, sort_params, page_params)
    @products = query.call

    if @products.empty?
      render json: { data: [] }, status: :not_found
    else
      render json: @products, status: :ok
    end
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

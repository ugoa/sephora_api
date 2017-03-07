class ProductsController < ApplicationController

  def index
    # search method provided by ransack
    @q = Product.search(filter_params)
    @q.sorts = sort_params if sort_params
    @products = @q.result.page(page_params[:number]).per(page_params[:size])

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

class ProductsController < ApplicationController

  def index
    @search = Product.search(filter_params)
    @search.sorts = sort_params if sort_params
    @products = @search.result.page(page_params[:number]).per(page_params[:size])
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

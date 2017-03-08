class ProductQueryService
  def initialize(filter = {}, sort = nil, page = {})
    @filter = filter
    @sort = sort
    @page = page
  end

  def call(*args)
    # search method provided by ransack
    q = Product.search(@filter)
    q.sorts = @sort if @sort
    q.result.page(@page[:number]).per(@page[:size])
  end
end

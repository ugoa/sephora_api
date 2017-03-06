class ApplicationController < ActionController::API
  before_action :filter_params, :sort_params

  private
    def filter_params
      @filter_params ||= params.except(:sort, :page)
    end

    def sort_params
      # convert `sort=-price,name` in `params` to ['price desc', 'name asc']
      return nil unless params[:sort]
      @sort_params ||= params[:sort].delete('').split(',').map do |option|
        option[0] == '-' ? "#{option[1..-1]} desc" : "#{option} asc"
      end
    end

    def page_params
      @page_params ||= {
        number: params.dig('page', 'number') || 1,
        size: params.dig('page', 'size') || 25,
      }
    end
end

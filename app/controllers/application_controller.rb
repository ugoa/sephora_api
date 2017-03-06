class ApplicationController < ActionController::API
  before_action :filter_params, :sort_params

  private

    def filter_params
      @filter_params ||= params
    end

    def sort_params
      # @sort_params ||= params[:sort].split(',')
    end

    def page_params
      @page_params ||= {
        number: params.dig('page', 'number') || 1,
        size: params.dig('page', 'size') || 25,
      }
    end

end

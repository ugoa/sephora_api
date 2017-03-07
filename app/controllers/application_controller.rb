class ApplicationController < ActionController::API
  before_action :filter_params, :sort_params

  private
    def filter_params
      return {} unless params[:filter] && params[:filter].respond_to?(:to_unsafe_h)
      params_hash = params[:filter].to_unsafe_h
      return {} if params_hash.empty?

      params_hash.each do |k, v|
        # Convert v as 'markup, brushes' to ['markup', 'brushes']
        params_hash[k] = v.delete('').split(',') if k.end_with? '_in'
      end
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

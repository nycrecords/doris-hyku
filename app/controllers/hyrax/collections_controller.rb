## Override from hyrax to fix collection search with params_for_query method

module Hyrax
  class CollectionsController < ApplicationController
    include CollectionsControllerBehavior
    include BreadcrumbsForCollections
    with_themed_layout :decide_layout
    load_and_authorize_resource except: [:index, :show, :create], instance_name: :collection

    # Renders a JSON response with a list of files in this collection
    # This is used by the edit form to populate the thumbnail_id dropdown
    def files
      result = form.select_files.map do |label, id|
        { id: id, text: label }
      end
      render json: result
    end

    private

    def form
      @form ||= form_class.new(@collection, current_ability, repository)
    end

    def decide_layout
      layout = case action_name
               when 'show'
                 '1_column'
               else
                 'dashboard'
               end
      File.join(theme, layout)
    end

    def params_for_query
      params.merge(q: params[:cq], search_field: 'all_fields' )
    end
  end
end

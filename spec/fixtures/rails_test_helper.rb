# frozen_string_literal: true
# monkey patching instead of creating a dummy app
require "ostruct"
module Jurou
  class RailsTestHelper
    include Jurou::ViewHelpers
    include ActionView::Helpers
    include ActionView::Context

    def initialize(action = nil, controller = "books", current_object = "book")
      @_jr_controller = controller
      @_jr_action = action
      unless current_object.nil?
        @_jr_current_object = OpenStruct.new(model_name: OpenStruct.new(param_key: current_object))
      end
    end

    def action_name
      @_jr_action
    end

    def controller_path
      @_jr_controller
    end

    # we only need to return "content" for testing purposes
    def content_for(name, content = nil, options = {}, &block)
      if content || block_given?
        if block_given?
          options = content if content
          content = capture(&block)
        end
      end
    end

    # dependent on having a :current_object in the rails app
    # (hopefully will be implemented as a seperate gem)
    def current_object
      @_jr_current_object
    end
  end
end

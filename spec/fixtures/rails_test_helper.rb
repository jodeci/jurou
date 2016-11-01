# monkey patching instead of creating a dummy app
require "ostruct"
module Jurou
  class RailsTestHelper
    include Jurou::ViewHelpers
    include ActionView::Helpers
    include ActionView::Context

    def initialize(action = nil, controller = "book", current_object = "book")
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

    # dependent on having a :current_object in the rails app
    # (hopefully will be implemented as a seperate gem)
    def current_object
      @_jr_current_object
    end
  end
end

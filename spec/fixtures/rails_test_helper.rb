# frozen_string_literal: true
# FIXME: consider switching to a dummy app instead of monkey patching
require "ostruct"
module Jurou
  class RailsTestHelper
    include Jurou::ViewHelpers
    include ActionView::Helpers
    include ActionView::Context

    BOOK_DATA = { model: "book", id: 1, data: { title: "神探伽利略", author: "東野圭吾", genre: "fantasy" } }

    def initialize(action = nil, controller = "books", options = BOOK_DATA)
      @_jr_action = action
      @_jr_controller = controller
      @_jr_current_object = mock_current_object(options)
    end

    def mock_current_object(options)
      return unless options
      @_jr_params = { id: options[:id] }
      object = OpenStruct.new(model_name: OpenStruct.new(param_key: options[:model]))
      options[:data].map { |key, value| object[key] = value }
      object
    end

    def action_name
      @_jr_action
    end

    def controller_path
      @_jr_controller
    end

    def controller_name
      @_jr_controller.to_s
    end

    # shikigami
    def current_object
      @_jr_current_object
    end

    def params
      @_jr_params
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
  end
end

# frozen_string_literal: true
module Jurou
  module ViewHelpers
    def jr_page_title(app_title = "jurou.app_title", divider = "|")
      "#{t(jr_page_title_translation_key, raise: true)} #{divider} #{t(app_title)}"
    rescue
      t(app_title)
    end

    def jr_content_for_page_title(text = nil, divider = "|")
      content_for(:jr_title) do
        if text
          "#{text} #{divider} #{jr_page_title}"
        else
          jr_page_title
        end
      end
    end
    alias jr_title jr_content_for_page_title

    def jr_simple_title(controller = nil, action = nil)
      unless action
        if controller
          action = :_label
        else
          controller = controller_path
          action = action_name
        end
      end
      I18n.t(jr_page_title_translation_key(controller, action))
    end

    def jr_collection(attribute, model = nil)
      jr_init_model(model)
      I18n.t("jurou.#{@_model}.#{attribute}").invert
    end

    def jr_table_row_for_attribute(attribute, value = nil, model = nil)
      jr_init_model(model)
      content_tag :tr do
        concat content_tag :th, jr_attribute(attribute, @_model)
        concat content_tag :td, value
      end
    end
    alias jr_row_attr jr_table_row_for_attribute

    def jr_table_row_for_value(attribute, value = nil, model = nil)
      jr_init_model(model)
      content_tag :tr do
        concat content_tag :th, jr_attribute(attribute, @_model)
        concat content_tag :td, jr_value(attribute, value, @_model)
      end
    end
    alias jr_row_val jr_table_row_for_value

    def jr_attribute(attribute, model = nil)
      jr_init_model(model)
      I18n.t("activerecord.attributes.#{@_model}.#{attribute}")
    end
    alias jr_attr jr_attribute

    def jr_value(attribute, value = nil, model = nil)
      jr_init_model(model)
      I18n.t("jurou.#{@_model}.#{attribute}.#{value}")
    end

    private

    def jr_init_model(model)
      @_model = model || controller_name.singularize
    end

    def jr_page_title_translation_key(controller = controller_path, action = action_name)
      :"jurou.page_titles.#{controller}.#{action}"
    end
  end
end

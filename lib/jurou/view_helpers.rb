# frozen_string_literal: true
module Jurou
  module ViewHelpers
    def jr_page_title(app_title = "jurou.app_title", divider = "|")
      "#{@jr_title}#{jr_page_title_by_controller_action(app_title, divider)}"
    end

    def jr_content_for_page_title(text = nil, divider = "|")
      @jr_title = "#{text} #{divider} " if text
      nil
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

    def jr_table_row(attribute, value = nil, model = nil)
      jr_init_model(model)
      content_tag :tr do
        concat content_tag :th, jr_attribute(attribute, @_model)
        concat content_tag :td, jr_init_value(attribute, value)
      end
    end
    alias jr_row jr_table_row

    def jr_table_row_translate_value(attribute, value = nil, model = nil)
      jr_init_model(model)
      content_tag :tr do
        concat content_tag :th, jr_attribute(attribute, @_model)
        concat content_tag :td, jr_value(attribute, value, @_model)
      end
    end
    alias jr_row_val jr_table_row_translate_value

    def jr_attribute(attribute, model = nil)
      jr_init_model(model)
      I18n.t("activerecord.attributes.#{@_model}.#{attribute}")
    end
    alias jr_attr jr_attribute

    def jr_value(attribute, value = nil, model = nil)
      jr_init_model(model)
      I18n.t("jurou.#{@_model}.#{attribute}.#{jr_init_value(attribute, value)}")
    end

    private

    def jr_init_model(model)
      @_model =
        if model
          model
        elsif params[:id] and current_object
          current_object.model_name.param_key
        else
          controller_name.singularize
        end
    end

    def jr_init_value(attribute, value)
      value || current_object.send(attribute)
    end

    def jr_page_title_by_controller_action(app_title, divider)
      "#{t(jr_page_title_translation_key, raise: true)} #{divider} #{t(app_title)}"
    rescue
      t(app_title)
    end

    def jr_page_title_translation_key(controller = controller_path, action = action_name)
      :"jurou.page_titles.#{controller}.#{action}"
    end
  end
end

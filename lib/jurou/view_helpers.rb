module Jurou
  module ViewHelpers
    def jr_page_title(app_title = "jurou.app_title", divider = "|")
      "#{t(jr_page_title_translation_key, raise: true)} #{divider} #{t(app_title)}"
    rescue
      t(app_title)
    end

    def jr_content_for_page_title(text = nil, divider = "|")
      content_for(:jr_title) do
        if text.nil?
          jr_page_title
        else
          "#{text} #{divider} #{jr_page_title}"
        end
      end
    end
    alias_method :jr_title, :jr_content_for_page_title

    def jr_collection(attribute, model = nil)
      jr_init_model(model)
      I18n.t("jurou.#{@_model}.#{attribute}").invert
    end

    def jr_table_row(attribute, model = nil, value = nil, translate = false)
      jr_init_model(model)
      content_tag :tr do
        concat content_tag :th, jr_attribute(attribute, @_model)
        concat content_tag :td, jr_init_value(attribute, value, translate)
      end
    end
    alias_method :jr_row, :jr_table_row

    def jr_attribute(attribute, model = nil)
      jr_init_model(model)
      I18n.t("activerecord.attributes.#{@_model}.#{attribute}")
    end
    alias_method :jr_attr, :jr_attribute

    def jr_value(attribute, model = nil, value = nil)
      jr_init_model(model)
      I18n.t("jurou.#{@_model}.#{attribute}.#{value}")
    end

    private

    def jr_init_model(model)
      @_model = model || current_object.model_name.param_key
    end

    def jr_init_value(attribute, value, translate)
      if translate
        jr_value(attribute, @_model, value)
      else
        value
      end
    end

    def jr_page_title_translation_key
      :"jurou.page_titles.#{controller_path}.#{action_name}"
    end

    def current_object?
      current_object if respond_to? :current_object
    rescue ActiveRecord::RecordNotFound
    end
  end
end

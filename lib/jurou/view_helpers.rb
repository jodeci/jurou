module Jurou
  module ViewHelpers
    def jr_collection (attribute, model = nil)
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

    def jr_attribute(attribute, model = nil)
      jr_init_model(model)
      I18n.t("activerecord.attributes.#{@_model}.#{attribute}")
    end

    def jr_value(attribute, model = nil, value = nil)
      jr_init_model(model)
      I18n.t("jurou.#{@_model}.#{attribute}.#{value}")
    end

    alias_method :jr_row, :jr_table_row
    alias_method :jr_attr, :jr_attribute

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

    def current_object?
      current_object if respond_to? :current_object
    rescue ActiveRecord::RecordNotFound
    end
  end
end
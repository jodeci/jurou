module Jurou
  module ViewHelpers
    def jr_collection (attribute, object = default_object)
      I18n.t("jurou.#{object}.#{attribute}", raise: true).invert
    rescue
    end

    private

    def default_object
      if respond_to? :current_object
        current_object.model_name.param_key
      end
    end
  end
end

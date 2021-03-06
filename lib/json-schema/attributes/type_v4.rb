require 'json-schema/attribute'

module JSON
  class Schema
    class TypeV4Attribute < Attribute
      def self.validate(current_schema, data, fragments, processor, validator, options = {})
        union = true
        types = current_schema.schema['type']
        if !types.is_a?(Array)
          types = [types]
          union = false
        end

        return if types.any? { |type| data_valid_for_type?(data, type) }

        types = types.map { |type| type.is_a?(String) ? type : '(schema)' }.join(', ')
        message = format(
          "#{fragments.join('/')} must be a '%s'",
          types
        )

        validation_error(processor, message, fragments, current_schema, self, options[:record_errors])
      end
    end
  end
end

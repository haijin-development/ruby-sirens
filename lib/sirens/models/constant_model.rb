module Sirens
    class ConstantModel

        # Initializing

        def initialize(name:, value:)
            super()

            @name = name
            @value = value
        end

        attr_reader :name,
            :value

        def display_string()
            value_print_string = value.inspect

            "#{name} = #{value_print_string}"
        end
    end
end
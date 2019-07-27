require 'stringio'

module Sirens
    class MethodModel

        # Initializing

        def initialize()
            super()

            @method = ValueModel.new
            @location = ValueModel.new
            @source_code = ValueModel.new
        end

        attr_reader :method,
            :location,
            :source_code

        def set_method(method)
            if method.nil?
                @method.set_value(nil)
                @location.set_value(nil)
                @source_code.set_value(nil)

                return
            end

            @method.set_value(method)

            @location.set_value(method.source_location)

            @source_code.set_value(method.source_code)
        end
    end
end
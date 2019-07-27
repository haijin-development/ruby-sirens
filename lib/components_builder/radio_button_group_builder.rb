module Sirens
    class RadioButtonGroupBuilder

        # Initializing

        def initialize()
            @buttons = []
        end

        # Evaluating

        def render(&block)
            @buttons = []

            instance_exec(self, &block)

            @buttons
        end

        # List columns

        def radio_button(props = Hash[])
            props[:previous_button] = @buttons.last

            @buttons << RadioButton.new(props)
        end
    end
end
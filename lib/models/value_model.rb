require 'observer'

module Sirens
    class ValueModel
        include Observable

        class << self
            def on(value)
                self.new(value)
            end
        end

        # Initializing

        def initialize(value = nil)
            super()

            @value = value
        end

        # Accessing

        def value()
            @value
        end

        def set_value(new_value)
            return if value == new_value

            old_value = value

            @value = new_value

            announce_value_changed(new_value: new_value, old_value: old_value)
        end

        def announce_value_changed(new_value:, old_value:)
            changed

            notify_observers(
                ValueChanged.new(new_value: new_value, old_value: old_value)
            )
        end
    end

    # Events

    class ValueChanged
        def initialize(new_value:, old_value:)
            @new_value = new_value
            @old_value = old_value
        end

        attr_reader :new_value, :old_value
    end
end
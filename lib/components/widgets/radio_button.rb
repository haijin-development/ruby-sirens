module Sirens
    class RadioButton < PrimitiveComponent
        ##
        # Returns a ButtonView.
        #
        def create_view()
            previous_button = props[:previous_button].nil? ? nil : props[:previous_button].view

            RadioButtonView.new(
                previous_button: previous_button,
                on_toggled: proc{ |state:| on_toggled(state: state) }
            )
        end

        # Actions

        def click()
            view.click
        end

        # Events

        def on_value_changed(announcement)
            view.set_value(announcement.new_value)
        end

        def on_toggled(state:)
            return if model.nil?

            model.set_selection(props[:id]) if state == true
        end
    end
end
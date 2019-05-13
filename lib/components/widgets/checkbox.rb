module Sirens
    class Checkbox < PrimitiveComponent
        ##
        # Returns a CheckButtonView.
        #
        def create_view()
            CheckButtonView.new(on_toggled: proc{ |state:| on_toggled(state: state) })
        end

        ##
        # Returns a default model if none is given during the initialization of this component.
        #
        def default_model()
            ValueModel.on(false)
        end

        # Actions

        def click()
            view.click
        end

        def sync_ui_from_model()
            view.set_value(model.value) unless view.nil?
        end

        # Events

        def on_value_changed(announcement)
            view.set_value(announcement.new_value)
        end

        def on_toggled(state:)
            return if model.nil?

            model.set_value(state)
        end
    end
end
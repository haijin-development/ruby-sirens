module Sirens
    class InputText < PrimitiveComponent
        ##
        # Returns a TextView.
        #
        def create_view()
            InputTextView.new
        end

        ##
        # Returns a default model if none is given during the initialization of this component.
        #
        def default_model()
            ValueModel.on('')
        end

        def sync_ui_from_model()
            view.set_text(model.value) unless view.nil?
        end

        # Events

        def on_value_changed(announcement)
            view.set_text(announcement.new_value)
        end
    end
end
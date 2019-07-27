module Sirens
    class InputTextView < WidgetView

        # Initializing

        def initialize_handles()
            @main_handle = Gtk::Entry.new
        end

        def subscribe_to_ui_events()
        end

        # Accessing

        def text()
            main_handle.buffer.text
        end

        def set_text(text)
            text = '' if text.nil?

            main_handle.buffer.text = text
        end
    end
end
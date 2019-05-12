module Haijin::Gtk
    class Button < Component

        # Initializing

        def initialize_handles()
            @main_handle = Gtk::Button.new()
        end

        def subscribe_to_ui_events()
            main_handle.signal_connect('clicked') {
                on_clicked
            }
        end

        # Events

        def on_clicked()
            props[:on_clicked].call(self) unless props[:on_clicked].nil?
        end
    end
end
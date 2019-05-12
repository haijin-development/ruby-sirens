module Haijin::Gtk
    class Window < Component

        # Initializing

        def initialize_handles()
            @main_handle = Gtk::Window.new()
        end

        def subscribe_to_ui_events()
            main_handle.signal_connect("delete_event") {
                false
            }

            main_handle.signal_connect("destroy") {
              Gtk.main_quit
            }
        end

    end
end
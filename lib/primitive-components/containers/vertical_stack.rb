module Haijin::Gtk
    class VerticalStack < Stack

        # Initializing

        def initialize_handles()
            space = props.fetch(:space, 0)

            @main_handle = Gtk::Box.new(:vertical, space)
        end

        # Asking

        def is_horizontal()
            true
        end
    end
end
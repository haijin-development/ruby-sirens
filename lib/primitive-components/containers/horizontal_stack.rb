module Haijin::Gtk
    class HorizontalStack < Stack

        # Initializing

        def initialize_handles()
            space = props.fetch(:space, 0)

            @main_handle = Gtk::Box.new(:horizontal, space)
        end

        # Asking

        def is_horizontal()
            true
        end
    end
end
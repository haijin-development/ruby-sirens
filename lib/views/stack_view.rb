module Sirens
    class StackView < View

        # Initializing

        def initialize(orientation)
            @orientation = orientation

            super()
        end

        def initialize_handles()
            @main_handle = Gtk::Box.new(@orientation, 0)
        end

        def subscribe_to_ui_events()
        end

        ##
        # Adds a child_view.
        #
        def add_view(view, expand: true, fill: true, padding: 0)
            main_handle.pack_start(view.main_handle, expand: expand, fill: fill, padding: padding)
        end
    end
end
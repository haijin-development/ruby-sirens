module Sirens
    class SplitterView < View

        # Initializing

        def initialize(orientation:, on_size_allocation:)
            @orientation = orientation
            @on_size_allocation = on_size_allocation

            super()
        end

        def initialize_handles()
            @main_handle = Gtk::Paned.new(@orientation)
        end

        def subscribe_to_ui_events()
            main_handle.signal_connect('size-allocate') {
                @on_size_allocation.call(
                    width: main_handle.allocation.width,
                    height: main_handle.allocation.height
                )
            }
        end
    end
end
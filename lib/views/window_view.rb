module Sirens
    class WindowView < View

        # Class methods

        class << self
            ##
            # Answer the styles accepted by this view.
            #
            def view_accepted_styles()
                super() + [:title].freeze
            end
        end

        # Initializing

        def initialize_handles()
            @main_handle = Gtk::Window.new()

            Sirens.register_window
        end

        def subscribe_to_ui_events()
            main_handle.signal_connect("delete_event") {
                false
            }

            main_handle.signal_connect("destroy") {
              Sirens.unregister_window
            }
        end

        # Styles

        def width=(value)
            main_handle.default_width = value
        end

        def height=(value)
            main_handle.default_height = value
        end

        def title=(value)
            main_handle.title = value
        end

        def title()
            main_handle.title
        end
    end
end
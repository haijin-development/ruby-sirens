module Sirens
    class CheckboxView < View

        # Class methods

        class << self
            ##
            # Answer the styles accepted by this view.
            #
            def view_accepted_styles()
                super() + [:label].freeze
            end
        end

        # Initializing

        def initialize(on_toggled:)
            super()

            @on_toggled_block = on_toggled
        end

        def initialize_handles()
            @main_handle = Gtk::CheckButton.new()
        end

        def subscribe_to_ui_events()
            main_handle.signal_connect('clicked') {
                on_toggled
            }
        end

        # Styles

        def label=(value)
            main_handle.label = value
        end

        def label()
            main_handle.label
        end

        # Actions

        def click()
            main_handle.clicked
        end

        # Querying

        def get_value()
            main_handle.active?
        end

        def set_value(boolean)
            main_handle.active = boolean
        end

        # Events

        def on_toggled()
            @on_toggled_block.call(state: get_value)
        end
    end
end
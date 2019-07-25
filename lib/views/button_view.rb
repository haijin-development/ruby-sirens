module Sirens
    class ButtonView < WidgetView

        # Class methods

        class << self
            ##
            # Answer the styles accepted by this view.
            #
            def view_accepted_styles()
                super() + [:label, :on_clicked].freeze
            end
        end

        # Initializing

        def initialize_handles()
            @main_handle = Gtk::Button.new()
            @on_clicked = nil
        end

        def subscribe_to_ui_events()
            main_handle.signal_connect('clicked') {
                on_clicked
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

        # Handlers

        def on_clicked=(block)
            @on_clicked = block
        end

        # Events

        def on_clicked()
            @on_clicked.call(self) unless @on_clicked.nil?
        end
    end
end
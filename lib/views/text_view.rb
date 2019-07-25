module Sirens
    class TextView < WidgetView
        # Class methods

        class << self
            ##
            # Answer the styles accepted by this view.
            #
            def view_accepted_styles()
                super() + [:wrap_mode].freeze
            end
        end

        # Initializing

        def initialize_handles()
            @text_view = Gtk::TextView.new

            @main_handle = Gtk::ScrolledWindow.new
            @main_handle.set_policy(:automatic, :always)

            @main_handle.add(@text_view)
        end

        # Hooking GUI signals

        def subscribe_to_ui_events()
            text_view.signal_connect('populate-popup') do |text_view, menu|
                menu_view = MenuView.new(menu_handle: menu)

                @populate_popup_menu_block.call(menu: menu_view)

                menu.show_all
            end
        end

        # Styles

        def wrap_mode=(value)
            text_view.wrap_mode = value
        end

        def wrap_mode()
            text_view.wrap_mode
        end

        def background_color=(value)
            state_colors_from(value).each_pair do |state, value|
                next if value.nil?

                text_view.override_background_color( state, Gdk::RGBA.parse(value) )
            end
        end

        def foreground_color=(value, state: :normal)
            state_colors_from(value).each_pair do |state, value|
                next if value.nil?

                text_view.override_color( state, Gdk::RGBA.parse(value) )
            end
        end

        def state_colors_from(value)
            colors = Hash[
                normal: nil,
                active: nil,
                prelight: nil,
                selected: nil,
                insensitive: nil,
            ]

            if value.kind_of?(Hash)
                value.each_pair do |state, value|
                    colors[state] = value
                end
            else
                colors[:normal] = value
            end

            colors
        end

        # Accessing

        def text_view()
            @text_view
        end

        def text()
            text_view.buffer.text
        end

        def set_text(text)
            text = '' if text.nil?

            text_view.buffer.text = text
        end

        # Querying

        ##
        # Returns the selected text of nil if no text is selected.
        #
        def selected_text()
            selection_bounds = text_view.buffer.selection_bounds

            return if selection_bounds.nil?

            text_view.buffer.get_text(selection_bounds[0], selection_bounds[1], false)
        end
    end
end
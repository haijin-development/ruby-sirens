require 'set'

module Sirens
    ##
    # A View is the library binding to a GUI interface handle.
    # It is not a Component but is wrapped by a PrimitiveComponent.
    # a View takes care of handling the internals of the GUI objects such as handles, events, default initialization,
    # etc.
    #
    # By separating the View from the PrimitiveComponent that wraps it makes the PrimitiveComponents responsibilities
    # more consistent with regular Components and it makes it easier to switch between GUI libraries
    # (say, from Gtk to Qt).
    #
    class View

        # Class methods

        class << self
            ##
            # Answer the styles accepted by this view.
            #
            def accepted_styles()
                @accepted_styles ||= Set.new(view_accepted_styles)
            end

            ##
            # Answer the styles accepted by this view.
            #
            def view_accepted_styles()
                [ :width, :height, :background_color, :foreground_color ].freeze
            end
        end

        # Initializing

        ##
        # Initializes this View handles
        #
        def initialize()
            @event_handles = Hash[]

            @main_handle = nil

            initialize_handles

            subscribe_to_ui_events
        end

        ## Instantiates this view handles.
        # A View usually has a single handle to the GUI library, but in same cases it may have more than one.
        # For instance when adding a Scroll decorator to the actual widget.
        #
        def initialize_handles()
            raise RuntimeError.new("Subclass #{self.class.name} must implement the method ::initialize_handles().")
        end

        ##
        # Subscribes this View to the events/signals emitted by the GUI handle(s) of interest.
        # When an event/signal is received calls the proper event_handler provided by the PrimitiveComponent,
        # if one was given.
        #
        # This mechanism of event handler callbacks is more simple and lightweight than making this View to announce
        # events using the Observer pattern, and since there is only one PrimitiveComponent wrapping each View
        # using the Observer pattern would be unnecessary complex.
        #
        def subscribe_to_ui_events()
            raise RuntimeError.new("Subclass #{self.class.name} must implement the method ::subscribe_to_ui_events().")
        end

        # Accessing

        ##
        # Returns the main handle of this View.
        # The main handle is the one that this View parent add as its child.
        # Also, it is the handle that receives the style props and events by default.
        #
        def main_handle()
            @main_handle
        end

        # Styling

        ##
        # Answer the styles accepted by this view.
        #
        def accepted_styles()
            self.class.accepted_styles
        end

        ##
        # Applies each prop in props to the actual GUI object.
        #
        def apply_props(props)
            accepted_styles = self.accepted_styles

            props.each_pair { |prop, value|
                apply_prop(prop, value) if accepted_styles.include?(prop)
            }
        end

        ##
        # Apply the prop to the actual GUI object.
        #
        def apply_prop(prop, value)
            setter = prop.to_s + '='

            send(setter, value)
        end

        # Styles

        def width=(value)
            main_handle.width_request = value
        end

        def width()
            main_handle.width_request
        end

        def height=(value)
            main_handle.height_request = value
        end

        def height()
            main_handle.height_request
        end

        def background_color=(value)
            state_colors_from(value).each_pair do |state, value|
                next if value.nil?

                main_handle.override_background_color( state, Gdk::RGBA.parse(value) )
            end
        end

        def foreground_color=(value, state: :normal)
            state_colors_from(value).each_pair do |state, value|
                next if value.nil?

                main_handle.override_color( state, Gdk::RGBA.parse(value) )
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

        # Showing/hiding

        ##
        # Makes this component visible.
        #
        def show()
            main_handle.show_all
        end

        # Child views

        ##
        # Adds a child_view.
        #
        def add_view(child_view)
            main_handle.add(child_view.main_handle)
        end

        ##
        # Removes a child view.
        #
        def remove_view(child_view)
            main_handle.remove(child_view.main_handle)
        end

        # Popup menu

        def populate_popup_menu_block=(populate_popup_menu_block)
            @populate_popup_menu_block = populate_popup_menu_block
        end

        ##
        # Create and show a popup menu
        #
        def show_popup_menu(props)
            menu = MenuView.new

            @populate_popup_menu_block.call(menu: menu)

            menu.open(props) unless menu.empty?
        end
    end
end
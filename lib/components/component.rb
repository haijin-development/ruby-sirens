module Sirens
    class Component < AbstractComponent

        # Initializing

        ##
        # Initializes this component
        #
        def initialize(props = Hash[])
            super(props)

            build
        end

        def create_view()
            nil
        end

        ##
        # Configures the widget with its model, styles and child widgets but does not apply the styles yet.
        # This method is called when opening a widget with ::open and after calling ::initialize_handles.
        # The building of the widget includes defining its model, its style props and its event blocks,
        # but does no apply those styles yet. The wiring and synchronization of the component to the
        # widget is done in the ::post_build method.
        #
        def build()
            set_model( props.key?(:model) ? props[:model] : default_model )

            render_with(LayoutBuilder.new(root_component: self))

            self
        end

        ##
        # Hook method to allow each Component subclass to define its default styles and compose its child components.
        # Subclasses are expected to implement this method.
        def render_with(layout)
            raise RuntimeError.new("Class #{self.class.name} must implement a ::render_with(layout) method.")
        end

        ##
        # Returns the top most view of this component.
        #
        def main_view()
            main_component.main_view
        end
    end
end
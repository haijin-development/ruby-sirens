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
            ComponentView.new
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


        # Accessing
    
        def main_child_component()
            @child_components.first
        end

        # Rendering

        ##
        # Hook method to allow each Component subclass to define its default styles and compose its child components.
        # Subclasses are expected to implement this method.
        def render_with(layout)
            raise RuntimeError.new("Class #{self.class.name} must implement a ::render_with(layout) method.")
        end

        ##
        # Adds the child_component to this component.
        #
        def on_component_added(child_component)
            @view.add_view(child_component.view)
        end

        def open()
            main_child_component.open
        end
    end
end
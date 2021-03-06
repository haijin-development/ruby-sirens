module Sirens
    class AbstractComponent
        # Opening

        ##
        # Todo: Opens a new window with this component. Currently only works for actual Windows.
        #
        def self.open(props = Hash[])
            self.new(props).tap { |window|
                window.open
            }
        end

        # Initializing

        ##
        # Initializes this component.
        #
        def initialize(props = Hash[])
            super()

            @props = Hash[]
            @child_components = []
            @props = props

            @view = create_view
        end

        ##
        # Creates the PrimitiveView that this component wraps.
        # This method must be implemented by each subclass.
        #
        def create_view()
            raise RuntimeError.new("Class #{self.class.name} must implement a ::create_view() method.")
        end

        # Accessing

        ##
        # Returns this component props.
        #
        def props()
            @props
        end

        ##
        # Applies the given props to the current component.props.
        # The component.props that are not included in given props remain untouched.
        #
        def set_props(props)
            @props.merge!(props)
        end

        ##
        # Returns the child components of this component.
        #
        def child_components()
            @child_components
        end

        ##
        # Returns a default model if none is given during the initialization of this component.
        #
        def default_model()
            nil
        end

        ##
        # Returns the current model of this component.
        #
        def model()
            @props[:model]
        end

        ##
        # Sets the current model of this component.
        #
        def set_model(new_model)
            old_model = model

            @props[:model] = new_model

            on_model_changed(new_model: new_model, old_model: old_model)
        end

        ##
        # Returns this component View.
        #
        def view()
            @view
        end

        # Child components

        ##
        # Adds the child_component to this component.
        #
        def add_component(child_component)
            @child_components << child_component

            on_component_added(child_component)

            child_component
        end

        ##
        # Adds the child_component to this component.
        #
        def add_all_components(components)
            components.each do |child_component|
                add_component(child_component)
            end

            self
        end

        ##
        # Removes the last child component and returns it.
        #
        def remove_last_component()
            remove_component_at(index: @child_components.size - 1)
        end

        ##
        # Removes the component at the index-th position.
        #
        def remove_component_at(index:)
            component = @child_components.delete_at(index)

            @view.remove_view(component.view)

            component
        end

        ##
        # This method is called right after adding a child component.
        # Subclasses may use it to perform further configuration on this component or its children.
        #
        def on_component_added(child_component)
        end

        def on_model_changed(new_model:, old_model:)
        end
    end
end
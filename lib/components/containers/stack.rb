module Sirens
    ##
    # Component that wraps a StackView.
    #
    class Stack < PrimitiveComponent

        # Class methods

        class << self
            def horizontal(props = Hash[])
                props[:orientation] = :horizontal

                self.new(props)
            end

            def vertical(props = Hash[])
                props[:orientation] = :vertical

                self.new(props)
            end
        end

        ##
        # Returns a StackView.
        #
        def create_view()
            StackView.new(props.fetch(:orientation))
        end

        ##
        # Adds the child_component to this component.
        #
        def on_component_added(child_component)
            view.add_view(
                child_component.view,
                expand: child_component.props.fetch(:stack_expand, true),
                fill: child_component.props.fetch(:stack_fill, true),
                padding: child_component.props.fetch(:stack_padding, 0)
            )
        end
    end
end
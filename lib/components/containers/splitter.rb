module Sirens
    ##
    # Component that wraps a StackView.
    #
    class Splitter < PrimitiveComponent

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

        def on_component_added(child_component)
            splitter_proportion = child_component.props.fetch(:splitter_proportion)

            child_component.view.set_attribute(:splitter_proportion, splitter_proportion)

            super(child_component)
        end

        ##
        # Returns a SplitterView.
        #
        def create_view()
            SplitterView.new(
                orientation: orientation
            )
        end

        # Asking

        def orientation()
            props.fetch(:orientation)
        end
    end
end
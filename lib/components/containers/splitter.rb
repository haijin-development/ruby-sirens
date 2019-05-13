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

        ##
        # Returns a PanedView.
        #
        def create_view()
            PanedView.new(
                orientation: props.fetch(:orientation),
                on_size_allocation: proc{ |width:, height:|
                    on_size_allocation(width: width, height: height)
                }
            )
        end

        ##
        # Adds the child_component to this component.
        #
        def add_component(child_component)
            if components.size < 2
                components << child_component

                on_component_added(child_component)

                return
            end

            last_child = remove_last_component

            new_splitter_proportion = 1.0 - components.first.props[:splitter_proportion]

            new_splitter = self.class.new(orientation: orientation)

            last_child.props[:splitter_proportion] = last_child.props[:splitter_proportion] / new_splitter_proportion
            new_splitter.add_component(last_child)

            child_component.props[:splitter_proportion] = child_component.props[:splitter_proportion] / new_splitter_proportion
            new_splitter.add_component(child_component)

            components << new_splitter
            on_component_added(new_splitter)
        end

        # Asking

        def orientation()
            props[:orientation]
        end

        # Events

        def on_size_allocation(width:, height:)
            components.each do |child_component|
                size_proportion = child_component.props[:splitter_proportion]

                next if size_proportion.nil?

                if orientation == :vertical
                    proportional_height = height * size_proportion

                    if child_component.props.key?(:height)
                        proportional_height = [proportional_height, child_component.props[:height]].max
                    end

                    child_component.main_view.height = proportional_height

                else
                    proportional_width = width * size_proportion

                    if child_component.props.key?(:width)
                        proportional_width = [proportional_width, child_component.props[:width]].max
                    end

                    child_component.main_view.width = proportional_width
                end
            end
        end
    end
end
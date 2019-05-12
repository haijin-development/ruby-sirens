module Haijin::Gtk
    class LayoutBuilder

        # Initializing

        def initialize(component)
            @components_stack = [component]
        end

        # Evaluating

        def render(props = Hash[], &block)
            current_component.set_props(props)

            instance_exec(self, &block)
        end

        # Accessing

        def current_component()
            @components_stack.last
        end

        # Stacks

        def horizontal_stack(props = {}, &block)
            stack = HorizontalStack.new(props)

            current_component.addComponent(stack)

            with_component_do(stack, &block) unless block.nil?
        end

        def vertical_stack(props = {}, &block)
            stack = VerticalStack.new(props)

            current_component.addComponent(stack)

            with_component_do(stack, &block) unless block.nil?
        end

        # Widgets

        def button(props)
            button = Button.new(props)

            current_component.addComponent(button)
        end

        # Lists

        def list(props = Hash[], &block)
            list = List.new(props)

            current_component.addComponent(list)

            with_component_do(list, &block) unless block.nil?
        end

        def list_column(props = Hash[])
            current_component.addColumnWithProps(props)
        end

        # Utility methods

        def with_component_do(component, &block)
            @components_stack << component

            begin
                block.call
            ensure
                @components_stack.pop
            end

        end
    end
end
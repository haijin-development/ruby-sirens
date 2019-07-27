module Sirens
    class SplitterView < WidgetView

        # Initializing

        def initialize(orientation:)
            @orientation = orientation

            super()
        end

        def initialize_handles()
            @main_handle = Gtk::Paned.new(@orientation)
        end

        def subscribe_to_ui_events()
            main_handle.signal_connect('size-allocate') { |widget, rectangle|
                on_size_allocation(width: rectangle.width, height: rectangle.height)
            }
        end

        ##
        # Adds the child_component to this component.
        #
        def add_view(child_view)
            @child_views << child_view

            if @child_views.size <= 2
                main_handle.add(child_view.main_handle)
            else
                paned = Gtk::Paned.new(@orientation)

                last_child_handle = main_handle.children.last

                main_handle.remove(last_child_handle)

                paned.add(last_child_handle)
                paned.add(child_view.main_handle)

                main_handle.add(paned)
            end
        end

        def is_horizontal()
            @orientation === :horizontal
        end

        def on_size_allocation(width:, height:)
            return if @is_first_size_allocation === false

            @is_first_size_allocation = false

            remaining_proportion = 1.0

            current_handle = main_handle

            @child_views.each_with_index do |child_view, index|

                return if index === @child_views.size

                return if current_handle.children.empty?

                proportion = child_view.attribute_at(:splitter_proportion)

                remaining_proportion = remaining_proportion - proportion

                children = current_handle.children

                first_child = children[0]

                set_proportional_size(
                    view_handle: first_child,
                    width: width,
                    height: height,
                    proportion: proportion
                )

                return if children.size < 2

                second_child = children[1]

                set_proportional_size(
                    view_handle: second_child,
                    width: width,
                    height: height,
                    proportion: remaining_proportion
                )

                current_handle = second_child
            end
        end

        def set_proportional_size(view_handle:, width:, height:, proportion:)
            if is_horizontal
                view_handle.set_size_request(width * proportion, height)
            else
                view_handle.set_size_request(width, height * proportion)
            end
        end
    end
end
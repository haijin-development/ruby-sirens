module Sirens
    class LayoutBuilder

        # Initializing

        def initialize(main_component:)
            @main_component = main_component

            @props = Hash[]
            @components = []
        end

        # Evaluating

        def render(props = Hash[], &build_block)
            instance_exec(@main_component, &build_block)

            @main_component.add_all_components(@components)
        end

        # Accessing

        def merge_to_current_props(props)
            @props.merge!(props)
        end

        # Current component model

        def model(object)
            merge_to_current_props(model: object)
        end

        # Current component props

        def styles(props)
            merge_to_current_props(props)
        end

        def props(props)
            merge_to_current_props(props)
        end

        def handlers(props)
            merge_to_current_props(props)
        end

        # Components

        def component(component, &build_block)
            build_component_from(Hash[], build_block) { |props, child_components|
                component.set_props(props)

                component.add_all_components(child_components)
            }
        end

        # Containers

        def window(props = Hash[], &build_block)
            build_component_from(props, build_block) { |props, child_components|
                Window.new(props)
                    .add_all_components(child_components)
            }
        end

        def horizontal_stack(props = Hash[], &build_block)
            build_component_from(props, build_block) { |props, child_components|
                Stack.horizontal(props)
                    .add_all_components(child_components)
            }
        end

        def vertical_stack(props = Hash[], &build_block)
            build_component_from(props, build_block) { |props, child_components|
                Stack.vertical(props)
                    .add_all_components(child_components)
            }
        end

        def horizontal_splitter(props = Hash[], &build_block)
            build_component_from(props, build_block) { |props, child_components|
                Splitter.horizontal(props)
                    .add_all_components(child_components)
            }
        end

        def vertical_splitter(props = Hash[], &build_block)
            build_component_from(props, build_block) { |props, child_components|
                Splitter.vertical(props)
                    .add_all_components(child_components)
            }
        end

        def tabs(props = Hash[], &build_block)
            build_component_from(props, build_block) { |props, child_components|
                Tabs.new(props)
                    .add_all_components(child_components)
            }
        end

        # Widgets

        def button(props = Hash[], &build_block)
            build_component_from(props, build_block) { |props, child_components|
                Button.new(props)
            }
        end

        def checkbox(props = Hash[], &build_block)
            build_component_from(props, build_block) { |props, child_components|
                Checkbox.new(props)
            }
        end

        def radio_button(props = Hash[], &build_block)
            build_component_from(props, build_block) { |props, child_components|
                RadioButton.new(props)
            }
        end

        def radio_buttons_group(props = Hash[], &build_block)
            buttons = RadioButtonGroupBuilder.new.render(&build_block)

            @components.concat(buttons)
        end

        def list(props = Hash[], &build_block)
            columns_builder = ColumnsBuilder.new.render(props, &build_block)

            props[:popup_menu] = columns_builder.popup_menu unless columns_builder.popup_menu.nil?

            List.new(props).tap { |list|
                list.define_columns(columns_builder.columns)

                @components << list
            }
        end

        def choices_list(props = Hash[], &build_block)
            columns_builder = ColumnsBuilder.new.render(props, &build_block)

            props[:popup_menu] = columns_builder.popup_menu unless columns_builder.popup_menu.nil?

            ListChoice.new(props).tap { |list|
                list.define_columns(columns_builder.columns)

                @components << list
            }
        end

        def input_text(props = Hash[], &build_block)
            build_component_from(props, build_block) { |props, child_components|
                InputText.new(props)
            }
        end

        def text(props = Hash[], &build_block)
            build_component_from(props, build_block) { |props, child_components|
                Text.new(props)
            }
        end

        def choices_tree(props = Hash[], &build_block)
            columns_builder = ColumnsBuilder.new.render(props, &build_block)

            props[:popup_menu] = columns_builder.get_popup_menu unless columns_builder.get_popup_menu.nil?

            TreeChoice.new(props).tap { |tree|
                tree.define_columns(columns_builder.columns)

                @components << tree
            }
        end

        def popup_menu(&block)
            merge_to_current_props(popup_menu: block)
        end

        # Utility methods

        def build_component_from(props = Hash[], build_block, &after_build_block)
            current_props = @props
            current_components = @components

            built_component = nil

            begin
                @props = props.clone
                @components = []

                build_block.call unless build_block.nil?

                built_component = after_build_block.call(@props, @components)
            ensure
                @props = current_props
                @components = current_components
            end

            @components << built_component unless built_component.nil?
        end

    end
end
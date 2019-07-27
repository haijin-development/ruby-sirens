module Sirens
    class LayoutBuilder

        # Initializing

        def initialize(root_component: nil)
            super()

            @root_component = root_component
            @built_props = Hash[]
            @built_components = []
        end

        # Accessing

        attr_reader :built_props
        attr_reader :built_components

        # Building

        def render(props: Hash[], &build_block)
            eval(props: props, &build_block)

            @root_component.add_all_components(built_components)

            self
        end

        def eval(props: Hash[], &build_block)
            merge_props(props)

            instance_exec(@root_component, &build_block) unless build_block.nil?

            self
        end

        def styles(props)
            merge_props(props)
        end

        def model(model)
            merge_props(model: model)
        end

        def merge_props(props)
            @built_props.merge!(props)
        end

        # Containers

        def component(component)
            @built_components << component
        end

        def window(props = Hash[], &build_block)
            LayoutBuilder.new.tap do |builder|
                builder.eval(props: props, &build_block)

                Window.new(builder.built_props).tap do |window|
                    window.add_all_components(builder.built_components)

                    @built_components << window
                end
            end
        end

        def horizontal_stack(props = Hash[], &build_block)
            LayoutBuilder.new.tap do |builder|
                builder.eval(props: props, &build_block)

                Stack.horizontal(builder.built_props).tap do |stack|
                    stack.add_all_components(builder.built_components)

                    @built_components << stack
                end
            end
        end

        def vertical_stack(props = Hash[], &build_block)
            LayoutBuilder.new.tap do |builder|
                builder.eval(props: props, &build_block)

                Stack.vertical(builder.built_props).tap do |stack|
                    stack.add_all_components(builder.built_components)

                    @built_components << stack
                end
            end
        end

        def horizontal_splitter(props = Hash[], &build_block)
            LayoutBuilder.new.tap do |builder|
                builder.eval(props: props, &build_block)

                Splitter.horizontal(builder.built_props).tap do |splitter|
                    splitter.add_all_components(builder.built_components)

                    @built_components << splitter
                end
            end
        end

        def vertical_splitter(props = Hash[], &build_block)
            LayoutBuilder.new.tap do |builder|
                builder.eval(props: props, &build_block)

                Splitter.vertical(builder.built_props).tap do |splitter|
                    splitter.add_all_components(builder.built_components)

                    @built_components << splitter
                end
            end
        end

        def tabs(props = Hash[], &build_block)
            LayoutBuilder.new.tap do |builder|
                builder.eval(props: props, &build_block)

                Tabs.new(builder.built_props).tap do |tabs|
                    tabs.add_all_components(builder.built_components)

                    @built_components << tabs
                end
            end
        end

        # Widgets

        def button(props = Hash[], &build_block)
            LayoutBuilder.new.tap do |builder|
                builder.eval(props: props, &build_block)

                @built_components << Button.new(builder.built_props)
            end
        end

        def checkbox(props = Hash[], &build_block)
            LayoutBuilder.new.tap do |builder|
                builder.eval(props: props, &build_block)

                @built_components << Checkbox.new(builder.built_props)
            end
        end

        def radio_button(props = Hash[], &build_block)
            LayoutBuilder.new.tap do |builder|
                builder.eval(props: props, &build_block)

                @built_components << RadioButton.new(builder.built_props)
            end
        end

        def radio_buttons_group(props = Hash[], &build_block)
            buttons = RadioButtonGroupBuilder.new.render(&build_block)

            @built_components.concat(buttons)
        end

        def list(props = Hash[], &build_block)
            columns_builder = ColumnsBuilder.new.render(props, &build_block)

            props[:popup_menu] = columns_builder.popup_menu unless columns_builder.popup_menu.nil?

            List.new(props).tap { |list|
                list.define_columns(columns_builder.columns)

                @built_components << list
            }
        end

        def choices_list(props = Hash[], &build_block)
            columns_builder = ColumnsBuilder.new.render(props, &build_block)

            props[:popup_menu] = columns_builder.popup_menu unless columns_builder.popup_menu.nil?

            ListChoice.new(props).tap { |list|
                list.define_columns(columns_builder.columns)

                @built_components << list
            }
        end

        def input_text(props = Hash[], &build_block)
            LayoutBuilder.new.tap do |builder|
                builder.eval(props: props, &build_block)

                @built_components << InputText.new(builder.built_props)
            end
        end

        def text(props = Hash[], &build_block)
            LayoutBuilder.new.tap do |builder|
                builder.eval(props: props, &build_block)

                @built_components << Text.new(builder.built_props)
            end
        end

        def choices_tree(props = Hash[], &build_block)
            columns_builder = ColumnsBuilder.new.render(props, &build_block)

            props[:popup_menu] = columns_builder.get_popup_menu unless columns_builder.get_popup_menu.nil?

            TreeChoice.new(props).tap { |tree|
                tree.define_columns(columns_builder.columns)

                @built_components << tree
            }
        end

        def popup_menu(&block)
            merge_props(popup_menu: block)
        end
    end
end
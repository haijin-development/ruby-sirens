module Sirens

    class MethodsList < Sirens::Component

        # Building

        def render_with(layout)
            layout.render do |component|
                vertical_stack do

                     horizontal_stack do
                         styles(
                             height: 30,
                             stack_expand: false
                         )

                        radio_buttons_group do
                            radio_button label: 'instance',
                                id: :instance,
                                model: component.props[:instance_or_class_methods_chooser],
                                stack_expand: false

                            radio_button label: 'class',
                                id: :class,
                                model: component.props[:instance_or_class_methods_chooser],
                                stack_expand: false
                        end

                        checkbox label: 'include inherit',
                            model: component.props[:show_inherit_methods]
                     end

                    choices_list do
                        model component.model

                        styles id: :methods_list,
                            show_headers: false

                        column label: '',
                            get_image_block: component.props[:get_method_image_block]

                        column label: 'Methods',
                            get_text_block: proc{ |method| method.name }
                    end

                    horizontal_stack do
                        styles(
                            height: 30,
                            stack_expand: false
                        )

                        checkbox label: 'public',
                            model: component.props[:show_public_methods]

                        checkbox label: 'protected',
                            model: component.props[:show_protected_methods]

                        checkbox label: 'private',
                            model: component.props[:show_private_methods]
                    end

                end
            end
        end
    end
end

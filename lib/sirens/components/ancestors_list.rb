module Sirens
    class AncestorsList < Sirens::Component

        # Building

        def render_with(layout)

            layout.render do |component|
                choices_list do
                    model component.model

                    styles(
                        show_headers: true
                    )

                    column label: '',
                        get_image_block: proc{ |a_module| Icons.icon_for(a_module) }

                    column label: 'Module ancestors',
                        get_text_block: proc{ |a_module| a_module.name }
                end
            end
        end
    end
end

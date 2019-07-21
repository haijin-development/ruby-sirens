module Sirens
    class ModulesList < Sirens::Component

        # Building

        def renderWith(layout)
            layout.render do |component|

                choices_list do
                    model component.model

                    styles(
                        show_headers: true
                    )

                    column label: 'Namespace modules',
                        get_text_block: proc{ |a_module| a_module.name }
                end

            end
        end
    end
end
module Sirens
    class NamespacesList < Sirens::Component

        # Building

        def renderWith(layout)
            layout.render do |component|

                choices_tree do
                    model component.model

                    styles show_headers: true

                    column label: 'Namespaces',
                        get_text_block: proc{ |a_module| a_module.name }
                end

            end
        end
    end
end
module Sirens

    class ConstantsList < Sirens::Component

        # Building

        def renderWith(layout)
            layout.render do |component|
                choices_list do
                    model component.model

                    styles(
                        show_headers: false
                    )

                    column label: 'Constants',
                        get_text_block: proc{ |constant| constant.display_string }
                end
            end
        end
    end
end

module Sirens
    class MethodSourceCode < Sirens::Component

        # Building

        def renderWith(layout)
            layout.render do |component|
                vertical_stack do
                    text do
                        model component.model.source_code
                    end

                    input_text do
                        model component.model.location

                        styles stack_expand: false
                    end
                end
            end
        end
    end
end

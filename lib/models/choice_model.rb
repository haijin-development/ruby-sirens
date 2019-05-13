module Sirens
    class ChoiceModel

        # Initializing

        def initialize(selection: nil, choices: [])
            super()

            @selection = ValueModel.on(selection)
            @choices = ListModel.on(choices)
        end

        # Accessing

        def selection()
            @selection
        end

        def set_selection(new_value)
            @selection.set_value(new_value)
        end

        def choices()
            @choices
        end

        def set_choices(list)
            @choices.set_list(list)
        end

        def item_at(index:)
            @choices[index]
        end

        # Asking

        def has_selection()
            ! @selection.value.nil?
        end
    end
end
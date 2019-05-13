module Sirens
    class ColumnsBuilder
        # Initializing

        def initialize()
            @props = Hash[]
            @columns = []
            @popup_menu = nil
        end

        def columns()
            @columns
        end

        def get_popup_menu()
            @popup_menu
        end

        # Evaluating

        def render(props, &block)
            @props = props
            @columns = []
            @popup_menu = nil

            instance_exec(self, &block)

            self
        end

        # Current component model

        def model(object)
            @props[:model] = object
        end

        # Current component props

        def styles(props)
            @props.merge!(props)
        end

        def props(props)
            @props.merge!(props)
        end

        def handlers(props)
            @props.merge!(props)
        end

        # List columns

        def column(props = Hash[])
            @columns << ColumnProps.new(props)
        end

        # Popup menu

        def popup_menu(&block)
            @popup_menu = block
        end
    end
end
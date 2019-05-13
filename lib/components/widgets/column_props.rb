module Sirens
    class ColumnProps
        def initialize(props = Hash[])
            @props = props
        end

         attr_reader :props

        def fetch(key, absent_value)
            @props.fetch(key, absent_value)
        end

        def [](key)
            @props[key]
        end

        def display_text_of(item)
            return item.to_s if ! @props.key?(:get_text_block)

            @props[:get_text_block].call(item)
        end
    end
end
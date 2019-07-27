module Sirens
    class ColumnProps
        def initialize(props = Hash[])
            @props = props
        end

        attr_reader :props

        def has_image_block?()
            @props.key?(:get_image_block)
        end

        def has_text_block?()
            @props.key?(:get_text_block)
        end

        def fetch(key, absent_value)
            @props.fetch(key, absent_value)
        end

        def [](key)
            @props[key]
        end

        def display_text_of(item)
            return item.to_s if ! has_text_block?

            @props[:get_text_block].call(item)
        end

        def display_image_of(item)
            @props[:get_image_block].call(item)
        end
    end
end
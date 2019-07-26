require 'pathname'

module Sirens
    class Icons

        def self.icons()
            @icons ||= Hash[
                ::Module => 'module.png',
                ::Class => 'class.png',
                ::Array => 'array.png',
                ::Hash => 'hash.png',
                ::TrueClass => 'true.png',
                ::FalseClass => 'false.png',
                ::String => 'string.png',
                ::Integer => 'number.png',
                ::Float => 'number.png',
            ]
        end

        # Initializing

        def self.icon_for(object)
            filename = icons.fetch(object.class)

            Pathname.new(__FILE__).dirname + '../../../resources/icons/' + filename 
        end

        def self.icon_filename_for_module(mod)
            return 'circle.png' if mod === ::Class

            return 'rectangle.png'
        end
    end
end
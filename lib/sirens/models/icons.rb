require 'pathname'

module Sirens
    class Icons

        # Initializing

        def self.icon_for(object)
            filename = object.is_a?(::Module) ?
                icon_filename_for_module(object) : icon_filename_for_object(object)

            Pathname.new(__FILE__).dirname + '../../../resources/icons/' + filename 
        end

        def self.icon_filename_for_module(mod)
            return 'circle.png' if mod === ::Class

            return 'rectangle.png'
        end
    end
end
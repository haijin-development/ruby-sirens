module Haijin::Gtk
    class Component

        class << self
            # Opening

            def openOn(props)
                self.new(props).open
            end
        end

        # Initializing

        def initialize(props)
            super()

            @props = props
            @main_handle = nil
            @components = []

            build
        end

        def build()
            initialize_handles

            renderWith(LayoutBuilder.new(self))

            apply_styles

            subscribe_to_ui_events
        end

        def initialize_handles()
        end

        def renderWith(layout)
        end

        def apply_styles()
            props.each_pair { |key, value|
                setter  = key.to_s + '='

                main_handle.send(setter, value) if main_handle.respond_to?(setter)
            }
        end

        def subscribe_to_ui_events()
        end

        # Accessing

        def main_handle()
            @main_handle
        end

        def props()
            @props
        end

        def set_props(props)
            @props.merge(props)

            main_handle.public_methods()
        end

        # Subcomponents

        def components()
            @components
        end

        def addComponent(component)
            @components << component

            main_handle.add(component.main_handle)
        end

        # Opening

        def open()
            main_handle.show_all
        end
    end
end
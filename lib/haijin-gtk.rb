require 'gtk3'

module Haijin
    module Gtk
        autoload(:Component, './lib/components/component.rb')

        autoload(:LayoutBuilder, './lib/layouts/layout_builder.rb')

        autoload(:Window, './lib/primitive-components/containers/window.rb')
        autoload(:Stack, './lib/primitive-components/containers/stack.rb')
        autoload(:HorizontalStack, './lib/primitive-components/containers/horizontal_stack.rb')
        autoload(:VerticalStack, './lib/primitive-components/containers/vertical_stack.rb')

        autoload(:Button, './lib/primitive-components/widgets/button.rb')
        autoload(:List, './lib/primitive-components/widgets/list.rb')
    end
end
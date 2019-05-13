module Sirens
    ##
    # Component that wraps a NotebookView.
    #
    class Tabs < PrimitiveComponent
        ##
        # Returns a StackView.
        #
        def create_view()
            NotebookView.new
        end

        ##
        # Adds the child_component to this component.
        #
        def on_component_added(child_component)
            super(child_component)

            tab_label_text = child_component.props[:tab_label]

            view.set_tab_label_at(index: components.size - 1, text: tab_label_text)
        end
    end
end
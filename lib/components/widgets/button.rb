module Sirens
    class Button < PrimitiveComponent
        ##
        # Returns a ButtonView.
        #
        def create_view()
            ButtonView.new
        end

        # Actions

        def click()
            view.click
        end
    end
end
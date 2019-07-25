module Sirens
    ##
    # Component that wraps a WindowView.
    #
    class Window < PrimitiveComponent
        ##
        # Returns a WindowView.
        #
        def create_view()
            WindowView.new
        end

        ##
        # Makes this component visible.
        #
        def show()
            view.show
        end

        def open()
            show()
        end
    end
end
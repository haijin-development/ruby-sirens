module Sirens
    class ComponentView < AbstractView

        def main_child_view()
            @child_views.first
        end

        def main_handle()
            main_child_view.main_handle
        end
    end
end
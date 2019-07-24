module Sirens
    class ComponentView < AbstractView

        def main_handle()
            @child_views.first.main_handle
        end
    end
end
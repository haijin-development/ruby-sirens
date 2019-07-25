module Sirens
    class TabsView < WidgetView

        # Initializing

        def initialize_handles()
            @main_handle = Gtk::Notebook.new
        end

        def subscribe_to_ui_events()
        end

        # Styles

        def set_tab_label_at(index:, text:)
            page_handle = main_handle.children[index]

            main_handle.set_tab_label_text(page_handle, text)
        end

        # Querying

        def tab_label_at(index:)
            main_handle.get_tab_label_text(main_handle.children[index])
        end
    end
end
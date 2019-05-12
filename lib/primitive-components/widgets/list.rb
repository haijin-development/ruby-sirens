module Haijin::Gtk
    class List < Component

        # Initializing

        def initialize_handles()
            list_store = Gtk::ListStore.new(String, String)

            iter = list_store.append()
            iter[0] = "Lisa"
            iter[1] = "Simpson"

            iter = list_store.append()
            iter[0] = "Bart"
            iter[1] = "Simpson"

            @main_handle = Gtk::TreeView.new(list_store)
        end

        def addColumnWithProps(props)
            column_type = props.fetch(:type, :text)
            column_index = main_handle.columns.size

            renderer = Gtk::CellRendererText.new

            col = Gtk::TreeViewColumn.new(props[:label], renderer, column_type => column_index)

            main_handle.append_column(col)
        end

        def subscribe_to_ui_events()
        end

        # Accessing

        def list_store()
            @main_handle.model
        end
    end
end
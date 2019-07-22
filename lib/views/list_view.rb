module Sirens
    class ListView < View

        # Class methods

        class << self
            ##
            # Answer the styles accepted by this view.
            #
            def view_accepted_styles()
                super() + [:show_headers, :clickable_headers].freeze
            end
        end

        # Initializing

        def initialize_handles()
            @tree_view = Gtk::TreeView.new()
            @tree_view.set_model(Gtk::ListStore.new(String))

            @main_handle = Gtk::ScrolledWindow.new
            @main_handle.add(tree_view)
            @main_handle.set_policy(:automatic, :automatic)

            @current_selection_indices = []

            @columns_props = []

            @on_selection_changed = nil
        end

        # Configuring callbacks

        def on_selection_changed_block(&block)
            @on_selection_changed_block = block

            self
        end

        def get_item_block(&block)
            @get_item_block = block

            self
        end

        # Building columns

        def list_store_type_for(column_props)
            return GdkPixbuf::Pixbuf if column_props.has_image_block?

            String
        end

        def define_columns(columns_props_array)
            @columns_props = columns_props_array

            list_store_types = @columns_props.collect { |type| list_store_type_for(type) }

            tree_view.set_model(Gtk::ListStore.new(*list_store_types))

            @columns_props.each do |each_column_props|
                add_column_with_props(each_column_props)
            end
        end

        def add_column_with_props(props)
            column_index = tree_view.columns.size

            col = nil

            column_label = props[:label]

            if props.has_image_block?
                renderer = Gtk::CellRendererPixbuf.new

                col = Gtk::TreeViewColumn.new(column_label, renderer, pixbuf: column_index)
            else
                renderer = Gtk::CellRendererText.new

                col = Gtk::TreeViewColumn.new(column_label, renderer, text: column_index)
            end

            tree_view.append_column(col)
        end

        # Hooking GUI signals

        def subscribe_to_ui_events()
            tree_view.selection.signal_connect('changed') { |tree_selection|
                on_selection_changed(tree_selection)
            }

            tree_view.signal_connect('row-activated') {
                @on_selection_action.call(self) unless @on_selection_action.nil?
            }
        end

        # Accessing

        def list_store()
            tree_view.model
        end

        def tree_view()
            @tree_view
        end

        ##
        # Returns the rows contents of the list.
        # For testing and debugging only.
        #
        def rows()
            list_store.collect { |store, path, iter|
                iter[0]
            }
        end

        # Styles

        def show_headers=(boolean)
            tree_view.headers_visible = boolean
        end

        def show_headers?()
            tree_view.headers_visible?
        end

        def clickable_headers=(boolean)
            tree_view.headers_clickable = boolean
        end

        def clickable_headers?()
            tree_view.headers_clickable?
        end

        # Handlers

        def on_selection_changed(tree_selection)
            indices = []
            items = []

            tree_selection.each do |tree_store, tree_path, iter|
                index = tree_path_to_index(tree_path)

                indices << index
                items << @get_item_block.call(index)
            end

            @on_selection_changed_block.call(
                selection_items: items,
                selection_indices: indices
            )
        end

        # Actions

        def clear_items()
            list_store.clear
        end

        # Adding

        def add_items(items:, index:)
            items.each_with_index do |each_item, i|
                add_item(item: each_item, index: index + i)
            end
        end

        def add_item(item:, index:)
            iter = list_store.insert(index)

            set_item_column_values(item: item, iter: iter)
        end

        # Updating

        def update_items(items:, indices:)
            items.each_with_index do |each_item, i|
                update_item(item: each_item, index: indices[i])
            end
        end

        def update_item(item:, index:)
            iter = list_store.get_iter(index.to_s)

            set_item_column_values(item: item, iter: iter)
        end

        # Removing

        def remove_items(items:, indices:)
            items.each_with_index do |each_item, i|
                remove_item(item: each_item, index: indices[i])
            end
        end

        def remove_item(item:, index:)
            iter = list_store.get_iter(index.to_s)

            list_store.remove(iter)
        end

        def set_item_column_values(item:, iter:)
            @columns_props.each_with_index { |column, column_index|
                colum_value = display_data_of(item, column, column_index)

                iter.set_value(column_index, colum_value)
            }
        end

        def display_data_of(item, column, column_index)
            if column.has_image_block?
                image_file = column.display_image_of(item).to_s

                return GdkPixbuf::Pixbuf.new(file: image_file, width: 16, height: 16)
            end

            column.display_text_of(item)
        end

        # Querying

        def selection_indices()
            indices = []

            tree_view.selection.each { |list, tree_path, iter|
                indices << tree_path_to_index(tree_path)
            }

            indices
        end

        def set_selection_indices(indices)
            if indices.empty?
                tree_view.unselect_all
                return
            end

            path = Gtk::TreePath.new(
                    indices.join(':')
                )

            tree_view.selection.select_path(path)

            tree_view.scroll_to_cell(path, nil, false, 0.0, 0.0)
        end

        # Utility methods

        def tree_path_to_index(tree_path)
            tree_path.to_s
                .to_i
        end
    end
end
module Sirens
    class TreeView < WidgetView

        # Class methods

        class << self
            ##
            # Answer the laze children placeholder.
            #
            def placeholder()
                @placeholder ||= '__placeholder__'
            end

            ##
            # Answer the styles accepted by this view.
            #
            def view_accepted_styles()
                super() + [:show_headers, :clickable_headers, :on_selection_action ].freeze
            end
        end

        # Initializing

        def initialize_handles()
            @tree_view = Gtk::TreeView.new
            @tree_view.set_model(Gtk::TreeStore.new(String))

            @main_handle = Gtk::ScrolledWindow.new
            @main_handle.add(tree_view)
            @main_handle.set_policy(:automatic, :automatic)

            @current_selection_indices = []

            @columns_props = []

            @on_selection_changed_block = nil
            @get_item_block = nil
            @get_children_block = nil
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

        def get_children_block(&block)
            @get_children_block = block

            self
        end

        # Building columns

        def define_columns(columns_props_array)
            @columns_props = columns_props_array

            tree_store_types = @columns_props
                .collect { |each_column_props| each_column_props.fetch(:type, :text) }
                .collect { |type| String }

            tree_view.set_model(Gtk::TreeStore.new(*tree_store_types))

            @columns_props.each do |each_column_props|
                add_column_with_props(each_column_props)
            end
        end

        def add_column_with_props(props)
            column_type = props.fetch(:type, :text)
            column_index = tree_view.columns.size

            renderer = Gtk::CellRendererText.new

            col = Gtk::TreeViewColumn.new(props[:label], renderer, column_type => column_index)

            tree_view.append_column(col)
        end

        # Hooking GUI signals

        def subscribe_to_ui_events()
            tree_view.selection.signal_connect('changed') { |tree_selection|
                on_selection_changed(tree_selection)
            }

            tree_view.signal_connect('row-activated') { |tree_view, tree_path, tree_column|
                on_selection_action(tree_path: tree_path, tree_column: tree_column)
            }

            tree_view.signal_connect('row-expanded') { |tree_view, iter, tree_path|
                on_row_expanded(iter: iter, tree_path: tree_path)
            }

            tree_view.signal_connect('button_press_event') do |tree_view, event|
                show_popup_menu(button: event.button, time: event.time) if (event.button == 3)
            end
        end

        # Accessing

        def tree_store()
            tree_view.model
        end

        def tree_view()
            @tree_view
        end

        ##
        # Returns the rows contents of the tree.
        # For testing and debugging only.
        #
        def rows()
            tree_store.collect { |store, path, iter|
                iter[0]
            }
        end

        def get_item_at(path:)
            @get_item_block.call(path: path)
        end

        def get_children_at(path:)
            @get_children_block.call(path: path)
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

        def on_selection_action=(block)
            @on_selection_action_block = block
        end

        # Handlers

        def on_selection_changed(tree_selection)
            indices = []
            items = []

            tree_selection.each do |tree_store, tree_path, iter|
                indices_path = tree_path.indices

                indices << indices_path
                items << get_item_at(path: indices_path)
            end

            @on_selection_changed_block.call(
                selection_items: items,
                selection_paths: indices
            )
        end

        def on_selection_action(tree_path:, tree_column:)
            return if @on_selection_action_block.nil?

            index_path = tree_path.indices

            item = get_item_at(path: index_path)

            @on_selection_action_block.call(index_path: index_path, item: item)
        end

        ##
        # To emulate a virtual tree elements are added with a child placeholder, the class placeholder constant.
        # The first time a node is expanded if it has the child placeholder it is replaced by the actual node
        # children.
        # The actual children are get using the get_children_block.
        #
        def on_row_expanded(iter:, tree_path:)
            child_iter = iter.first_child

            return if tree_store.get_value(child_iter, 0) != self.class.placeholder

            indices_path = tree_path.indices

            children = get_children_at(path: indices_path)

            tree_store.remove(child_iter)

            add_items(items: children, parent_iter: iter, index: 0)

            tree_view.expand_row(tree_path, false)
        end

        # Actions

        def clear_items()
            tree_store.clear
        end

        # Adding

        def add_items(items:, parent_iter:, index:)
            items.each_with_index do |each_item, i|
                add_item(item: each_item, parent_iter: parent_iter, index: index + i)
            end
        end

        def add_item(item:, parent_iter:, index:)
            iter = tree_store.insert(parent_iter, index)

            set_item_column_values(item: item, iter: iter)

            if parent_iter.nil?
                indices_path = [index]
            else
                indices_path = parent_iter.path.indices + [index]
            end

            children_count = get_children_at(path: indices_path).size

            if children_count > 0
                placeholder = tree_store.insert(iter, 0)

                placeholder[0] = self.class.placeholder
            end
        end

        # Updating

        def update_items(items:, indices:)
            items.each_with_index do |each_item, i|
                update_item(item: each_item, index: indices[i])
            end
        end

        def update_item(item:, index:)
            iter = tree_store.get_iter(index.to_s)

            set_item_column_values(item: item, iter: iter)
        end

        # Removing

        def remove_items(items:, indices:)
            items.each_with_index do |each_item, i|
                remove_item(item: each_item, index: indices[i])
            end
        end

        def remove_item(item:, index:)
            iter = tree_store.get_iter(index.to_s)

            tree_store.remove(iter)
        end

        def set_item_column_values(item:, iter:)
            @columns_props.each_with_index { |column, column_index|
                iter[column_index] = column.display_text_of(item)
            }
        end

        # Querying

        def selection_indices()
            indices = []

            tree_view.selection.each { |tree, path, iter|
                indices << path.to_s.to_i
            }

            indices
        end

        def set_selection_indices(indices)
            if indices.empty?
                tree_view.unselect_all
                return
            end

            tree_path = Gtk::TreePath.new(
                    indices.join(':')
                )

            expand(path: indices[0..-2]) if indices.size > 1

            tree_view.selection.select_path(tree_path)

            tree_view.scroll_to_cell(tree_path, nil, false, 0.0, 0.0)
        end

        def expand(path:)
            tree_path = Gtk::TreePath.new(
                    path.join(':')
                )

            tree_view.expand_row(tree_path, false)
        end
    end
end
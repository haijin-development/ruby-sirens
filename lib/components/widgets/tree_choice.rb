module Sirens
    class TreeChoice < PrimitiveComponent
        ##
        # Returns a WindowView.
        #
        def create_view()
            TreeView.new
                .on_selection_changed_block { |selection_items:, selection_paths:|
                        on_selection_changed(selection_items: selection_items, selection_paths: selection_paths)
                    }
                .get_item_block { |path:| model.item_at(path: path) }
                .get_children_block { |path:| model.children_at(path: path) }
        end

        ##
        # Defines the columns in the list with the given columns_props.
        # column_props is an Array of props Hashes, one Hash for each column to define.
        #
        def define_columns(columns_props_array)
            raise RuntimeError.new("The #{self.class.name} must have at least one column.") if columns_props_array.empty?

            view.define_columns(columns_props_array)

            # Sync again after adding the columns.
            sync_ui_from_model
        end

        ##
        # Returns a default model if none is given during the initialization of this component.
        #
        def default_model()
            TreeChoiceModel.new(roots: [], get_children_block: nil)
        end

        ##
        # Returns the root items of the tree.
        #
        def root_items()
            model.tree.roots
        end

        ##
        # Syncs the ui from the model.
        #
       def sync_ui_from_model()
            view.set_roots(model.tree.roots)
        end

        # Events

        ##
        # Subscribes this component to the model events
        #
        def subscribe_to_model_events()
            model.tree.add_observer(self, :on_tree_changed)
            model.selection.add_observer(self, :on_selected_value_changed)
        end

        def on_tree_changed(announcement)
            sync_ui_from_model
        end

        def on_selected_value_changed(announcement)
            selection_hierarchy = announcement.new_value

            indices_path = model.path_of(selection_hierarchy)

            view.set_selection_indices(indices_path)
        end

        def on_selection_changed(selection_items:, selection_paths:)
            model.set_selection_from_path(path: selection_paths.first) unless model.nil?
        end
    end
end
module Sirens
    class List < PrimitiveComponent
        ##
        # Returns a ListView.
        #
        def create_view()
            ListView.new
                .on_selection_changed_block { |selection_items:, selection_indices:|
                        on_selection_changed(selection_items: selection_items, selection_indices: selection_indices)
                    }
                .get_item_block { |index| model.item_at(index: index) }
        end

        ##
        # Defines the columns in the list with the given columns_props.
        # column_props is an Array of props Hashes, one Hash for each column to define.
        #
        def define_columns(columns_props_array)
            view.define_columns(columns_props_array)

            # Sync again after adding the columns.
            sync_ui_from_model
        end

        ##
        # Returns a default model if none is given during the initialization of this component.
        #
        def default_model()
            ListModel.new
        end

        ##
        # Hook method called when the model value changes.
        #
        def on_value_changed(announcement)
            if announcement.kind_of?(ListChanged)
                sync_ui_from_model
            elsif announcement.kind_of?(ItemsAdded)
                view.add_items(items: announcement.items, index: announcement.index)
            elsif announcement.kind_of?(ItemsUpdated)
                view.update_items(items: announcement.items, indices: announcement.indices)
            elsif announcement.kind_of?(ItemsRemoved)
                view.remove_items(items: announcement.items, indices: announcement.indices)
            else
                raise RuntimeError.new("Unknown announcement #{announcement.class.name}.")
            end
        end

        def sync_ui_from_model()
            return if view.nil?

            view.clear_items
            view.add_items(items: model.list, index: 0)
        end

        # Events

        def on_selection_changed(selection_items:, selection_indices:)
            return if props[:on_selection_changed].nil?

            props[:on_selection_changed].call(
                selection: selection_items,
                indices: selection_indices,
                list: self
            )
        end
    end
end
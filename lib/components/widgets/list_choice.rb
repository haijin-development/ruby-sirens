module Sirens
    class ListChoice < PrimitiveComponent
        ##
        # Returns a WindowView.
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
            ChoiceModel.new
        end

        ##
        # Returns the choices list
        #
        def choices()
            model.choices
        end

        ##
        # Subscribes this component to the model events
        #
        def subscribe_to_model_events()
            model.choices.add_observer(self, :on_choices_changed)
            model.selection.add_observer(self, :on_selected_value_changed)
        end

        ##
        # Method called when the choices list changes in the model.
        #
        def on_choices_changed(announcement)
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

        ##
        # Method called when the selected choice changes in the model.
        #
        def on_selected_value_changed(announcement)
            selected_value = announcement.new_value

            selection = choices.list.index(selected_value)

            selection.nil? ?
                view.set_selection_indices([]) : view.set_selection_indices([selection])
        end

        def sync_ui_from_model()
            return if view.nil?

            view.clear_items
            view.add_items(items: choices.list, index: 0)
        end

        # Events

        def on_selection_changed(selection_items:, selection_indices:)
            model.set_selection(selection_items.first) unless model.nil?
        end
    end
end
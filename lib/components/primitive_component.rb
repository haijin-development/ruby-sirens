module Sirens
    ##
    # PrimitiveComponent is a component wrapping a PrimitiveView.
    # A PrimitiveView implements the actual GUI binding to a Widget (a Gtk widget, for instance).
    # Besides acting as a regular Component, PrimitiveComponent also takes care of handling the PrimitiveView.
    #
    class PrimitiveComponent
        include ComponentBehaviour

        # Initializing

        ##
        # Initializes this component
        #
        def initialize(props = Hash[])
            super(props)

            @view = create_view

            @updating_view = false

            apply_props

            sync_ui_from_model
        end

        ##
        # Applies the props to the view.
        #
        def apply_props()
            if ! view.nil?
                @view.apply_props(props)

                @view.populate_popup_menu_block = proc { |menu:| populate_popup_menu(menu: menu) }
            end

            set_model( props.key?(:model) ? props[:model] : default_model )
        end

        ##
        # Creates the PrimitiveView that this component wraps.
        # This method must be implemented by each subclass.
        #
        def create_view()
            raise RuntimeError.new("Class #{self.class.name} must implement a ::create_view() method.")
        end

        # Accessing

        ##
        # Applies the given props to the current component.props.
        # The component.props that are not included in given props remain untouched.
        #
        def set_props(props)
            super(props)

            apply_props

            sync_ui_from_model if props.key?(:model)
        end

        ##
        # Returns this component View.
        #
        def view()
            @view
        end

        ##
        # Returns the top most view of this component.
        #
        def main_view()
            view
        end

        # Child components

        ##
        # Adds the child_component to this component.
        #
        def on_component_added(child_component)
            view.add_view(child_component.main_view)
        end

        # Events

        ##
        # Method called when this component model changes.
        # Unsubscribes this component from the current model events, subscribes this component to the
        # new model events and syncs the widget with the new model.
        #
        def on_model_changed(old_model:, new_model:)
            old_model.delete_observer(self) if old_model.respond_to?(:delete_observer)

            subscribe_to_model_events

            sync_ui_from_model
        end

        ##
        # Subscribes this component to the model events
        #
        def subscribe_to_model_events()
            model.add_observer(self, :on_value_changed) if model.respond_to?(:add_observer)
        end

        ##
        # Hook method called when the model value changes.
        # Note that the model remains the same, what changed is the value the model holds.
        # Subclasses may use this method to update other aspects of its model or perform actions.
        #
        def on_value_changed(announcement)
            sync_ui_from_model
        end

        ##
        # Populate the popup menu.
        #
        def populate_popup_menu(menu:)
            return if props[:popup_menu].nil?

            props[:popup_menu].call(menu: menu, menu_owner: self)
        end

        # Actions

        ##
        # Synchronizes the view to the models current state.
        #
        def sync_ui_from_model()
        end

        ##
        # Returns true if this component is currently updating the view.
        #
        def is_updating_view?()
            @updating_view
        end

        ##
        # Flags that this component is updating the view during the evaluation of the given &block.
        #
        def while_updating_view(&block)
            updating = is_updating_view?

            @updating_view = true

            begin
                block.call
            ensure
                @updating_view = updating
            end
         end
    end
end
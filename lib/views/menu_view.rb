module Sirens
    class MenuView < View

        # Initializing

        def initialize(menu_handle: Gtk::Menu.new)
            @main_handle = menu_handle
        end

        # Adding

        def item(label:, enabled: true, action:)
            menu_item_handle = Gtk::MenuItem.new(label: label)
            menu_item_handle.sensitive = enabled

            menu_item_handle.signal_connect('activate') { |props|
               action.call
            }

            @main_handle.append(menu_item_handle)
        end

        def separator()
            @main_handle.append(Gtk::SeparatorMenuItem.new)
        end

        ##
        # Subscribes this View to the events/signals emitted by the GUI handle(s) of interest.
        # When an event/signal is received calls the proper event_handler provided by the PrimitiveComponent,
        # if one was given.
        #
        def subscribe_to_ui_events()
        end

        # Asking

        def empty?()
            main_handle.children.empty?
        end

        def open(props)
            main_handle.show_all
            main_handle.popup(nil, nil, props[:button], props[:time])
        end
    end
end
require 'gtk3'

module Sirens
    class << self
        def browse(object: nil, klass: nil)
            if ! klass.nil?
                klass = klass.class if ! klass.kind_of?(Module)

                Sirens::ModuleBrowser.open_on(klass: klass)
            else
                ObjectBrowser.open_on(object: object)
            end

            Gtk.main if @opened_windows == 1
        end

        def register_window()
            @opened_windows = 0 if @opened_windows.nil?

            @opened_windows += 1
        end

        def unregister_window()
            @opened_windows -= 1

            Gtk.main_quit if @opened_windows == 0
        end
    end

    # Models
    autoload(:ValueModel, 'models/value_model.rb')
    autoload(:ListModel, 'models/list_model.rb')
    autoload(:VirtualTreeModel, 'models/virtual_tree_model.rb')
    autoload(:ChoiceModel, 'models/choice_model.rb')
    autoload(:TreeChoiceModel, 'models/tree_choice_model.rb')

    # Components
    autoload(:ComponentBehaviour, 'components/component_behaviour.rb')
    autoload(:Component, 'components/component.rb')
    autoload(:PrimitiveComponent, 'components/primitive_component.rb')
    autoload(:Window, 'components/containers/window.rb')
    autoload(:Stack, 'components/containers/stack.rb')
    autoload(:Splitter, 'components/containers/splitter.rb')
    autoload(:Tabs, 'components/containers/tabs.rb')
    autoload(:Button, 'components/widgets/button.rb')
    autoload(:Checkbox, 'components/widgets/checkbox.rb')
    autoload(:RadioButton, 'components/widgets/radio_button.rb')
    autoload(:List, 'components/widgets/list.rb')
    autoload(:ListChoice, 'components/widgets/list_choice.rb')
    autoload(:InputText, 'components/widgets/input_text.rb')
    autoload(:Text, 'components/widgets/text.rb')
    autoload(:TreeChoice, 'components/widgets/tree_choice.rb')

    # Layouts
    autoload(:ColumnProps, 'layouts/column_props.rb')
    autoload(:LayoutBuilder, 'layouts/layout_builder.rb')
    autoload(:ColumnsBuilder, 'layouts/columns_builder.rb')
    autoload(:RadioButtonGroupBuilder, 'layouts/radio_button_group_builder.rb')

    # Views
    autoload(:View, 'views/view.rb')
    autoload(:MenuView, 'views/menu_view.rb')
    autoload(:WindowView, 'views/window_view.rb')
    autoload(:StackView, 'views/stack_view.rb')
    autoload(:PanedView, 'views/paned_view.rb')
    autoload(:NotebookView, 'views/notebook_view.rb')
    autoload(:ButtonView, 'views/button_view.rb')
    autoload(:CheckButtonView, 'views/check_button_view.rb')
    autoload(:RadioButtonView, 'views/radio_button_view.rb')
    autoload(:ListView, 'views/list_view.rb')
    autoload(:EntryView, 'views/entry_view.rb')
    autoload(:TextView, 'views/text_view.rb')
    autoload(:TreeView, 'views/tree_view.rb')

    # Sirens
    
    autoload(:Icons, 'sirens/models/icons.rb')
    autoload(:ModuleBrowserModel, 'sirens/models/module_browser_model.rb')
    autoload(:MethodModel, 'sirens/models/method_model.rb')
    autoload(:ConstantModel, 'sirens/models/constant_model.rb')
    autoload(:ObjectBrowserModel, 'sirens/models/object_browser_model.rb')

    autoload(:ModuleBrowser, 'sirens/browsers/module_browser.rb')
    autoload(:ObjectBrowser, 'sirens/browsers/object_browser.rb')

    autoload(:NamespacesList, 'sirens/components/namespaces_list.rb')
    autoload(:ModulesList, 'sirens/components/modules_list.rb')
    autoload(:ClassBrowser, 'sirens/components/class_browser.rb')
    autoload(:AncestorsList, 'sirens/components/ancestors_list.rb')
    autoload(:MethodsList, 'sirens/components/methods_list.rb')
    autoload(:ConstantsList, 'sirens/components/constants_list.rb')
    autoload(:MethodSourceCode, 'sirens/components/method_source_code.rb')
end
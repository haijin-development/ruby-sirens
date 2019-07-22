module Sirens
    class ModuleBrowserModel

        # Initializing

        def initialize()
            super()

            @namespaces = TreeChoiceModel.new(
                selection: nil,
                roots: get_root_namespaces,
                get_children_block: proc { |namespace| get_modules_in(namespace) }
            )

            @modules = ChoiceModel.new(selection: nil, choices: [])
            @module_ancestors = ChoiceModel.new(selection: nil, choices: [])
            @methods = ChoiceModel.new(selection: nil, choices: [])
            @constants = ChoiceModel.new(selection: nil, choices: [])

            @instance_or_class_methods_chooser = ChoiceModel.new(selection: :instance, choices: [:instance, :class])
            @show_inherit_methods = ValueModel.on(false)

            @show_public_methods = ValueModel.on(true)
            @show_protected_methods = ValueModel.on(false)
            @show_private_methods = ValueModel.on(false)

            @method_source_code = MethodModel.new

            connect_models
        end

        attr_reader :namespaces,
            :modules,
            :module_ancestors,
            :methods,
            :constants,
            :instance_or_class_methods_chooser,
            :show_public_methods,
            :show_protected_methods,
            :show_private_methods,
            :show_inherit_methods,
            :method_source_code

        def connect_models()
            @namespaces.selection.add_observer(self, :on_namespace_changed)
            @modules.selection.add_observer(self, :on_class_changed)
            @module_ancestors.selection.add_observer(self, :on_module_changed)
            @methods.selection.add_observer(self, :on_method_changed)

            @instance_or_class_methods_chooser.selection.add_observer(self, :on_methods_filter_changed)
            @show_inherit_methods.add_observer(self, :on_methods_filter_changed)

            @show_public_methods.add_observer(self, :on_methods_filter_changed)
            @show_protected_methods.add_observer(self, :on_methods_filter_changed)
            @show_private_methods.add_observer(self, :on_methods_filter_changed)
        end

        # Actions

        def actual_namespace_hierarchy(a_module)
            namespaces = a_module.name.split('::')

            namespaces.pop if a_module.kind_of?(Class)

            hierarchy = [Object]

            namespaces.each { |module_name|
                hierarchy << hierarchy.last.const_get(module_name)
            }

            hierarchy
        end

        def select_namespace(namespace)
            hierarchy = actual_namespace_hierarchy(namespace)

            @namespaces.set_selection(hierarchy)
        end

        def select_class(a_class)
            hierarchy = actual_namespace_hierarchy(a_class)

            @namespaces.set_selection(hierarchy)
            @modules.set_selection(a_class)
            @module_ancestors.set_selection(a_class)
        end

        # Events

        def on_namespace_changed(announcement)
            namespace_hierarchy = announcement.new_value

            modules.set_choices(get_modules_in(namespace_hierarchy.last))
        end

        def on_class_changed(announcement)
            a_class = announcement.new_value

            ancestors = get_all_ancestors_of(a_class)

            module_ancestors.set_choices(ancestors)

            module_ancestors.set_selection(ancestors.last) unless ancestors.empty?
        end

        def on_module_changed(announcement)
            on_methods_filter_changed()
        end

        def on_methods_filter_changed(announcement = nil)
            a_module = module_ancestors.selection.value

            methods.set_choices(get_all_methods_in(a_module))
            constants.set_choices(get_all_constants_in(a_module))
        end

        def on_method_changed(announcement)
            method_name = announcement.new_value

            if method_name.nil?
                method_source_code.set_method(nil)
                return
            end

            method = method_named(method_name)

            method_source_code.set_method(method)
        end

        # Calculated

        def method_named(method_name)
            a_module = module_ancestors.selection.value

            if showing_instance_methods?
                a_module.instance_method(method_name)
            else
                a_module.method(method_name)
            end
        end

        def icon_for(method_name)
            method = method_named(method_name)

            filename = 'public-method.png'
            
            Pathname.new(__FILE__).dirname + '../../../resources/icons/' + filename             
        end

        ##
        # Answers all the namespaces in the running environment
        #
        def get_root_namespaces()
            return [Object]
        end

        ##
        # Answers child modules of a namespace
        #
        def get_modules_in(a_module)
            return [] if a_module.nil?

            modules = a_module.constants(false)
                .collect { |constant| a_module.const_get(constant) }
                .select { |constant| constant.kind_of?(Module) }
                .sort_by { |a_module| a_module.name }

            modules.prepend(a_module)
        end

        ##
        # Answers all the modules in the given class
        #
        def get_all_ancestors_of(a_class)
            return [] if a_class.nil?

            a_class.ancestors.reverse
        end

        ##
        # Answers all the methods in the given class
        #
        def get_all_methods_in(a_module)
            return [] if a_module.nil?

            methods = []

            inherit = show_inherit_methods.value

            if showing_instance_methods?
                methods.concat(a_module.private_instance_methods(inherit)) if showing_private_methods?
                methods.concat(a_module.protected_instance_methods(inherit)) if showing_protected_methods?
                methods.concat(a_module.public_instance_methods(inherit)) if showing_public_methods?
            else
                methods.concat(a_module.private_methods(inherit)) if showing_private_methods?
                methods.concat(a_module.protected_methods(inherit)) if showing_protected_methods?
                methods.concat(a_module.public_methods(inherit)) if showing_public_methods?
            end

            methods.sort
        end

        ##
        # Answers all the constants in the given class
        #
        def get_all_constants_in(a_module)
            return [] if a_module.nil?

            inherit = show_inherit_methods.value

            a_module.constants(inherit)
                .collect { |constant_name|
                    ConstantModel.new(name: constant_name, value: a_module.const_get(constant_name))
                }
                .select { |constant_model| ! constant_model.value.kind_of?(Module) }
                .sort_by { |constant_model| constant_model.name }
        end

        # Asking

        def showing_instance_methods?()
            instance_or_class_methods_chooser.selection.value == :instance
        end

        def showing_private_methods?()
            show_private_methods.value
        end

        def showing_protected_methods?()
            show_protected_methods.value
        end

        def showing_public_methods?()
            show_public_methods.value
        end
    end
end
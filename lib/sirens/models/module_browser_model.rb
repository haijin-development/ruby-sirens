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
            selected_method = announcement.new_value

            if selected_method.nil?
                method_source_code.set_method(nil)
                return
            end

            method_source_code.set_method(selected_method)
        end

        # Calculated

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
            all_methods_defined_in(a_module)
                .reject { |method| method.is_private? if !showing_private_methods? }
                .reject { |method| method.is_protected? if !showing_protected_methods? }
                .reject { |method| method.is_public? if !showing_public_methods? }
        end

        def all_methods_defined_in(mod)
            return [] if mod.nil?

            modules = show_inherit_methods.value === true ?
                mod.ancestors : [mod]

            all_methods = []

            modules.each do |a_module|
                if showing_instance_methods?
                    all_methods.concat(
                        a_module.private_instance_methods(false).collect { |method_name|
                            Sirens::Method.new(
                                mod: a_module,
                                name: method_name,
                                visibility: :private,
                                instance_method: true
                            )
                        }
                    )

                    all_methods.concat(
                        a_module.protected_instance_methods(false).collect { |method_name|
                            Sirens::Method.new(
                                mod: a_module,
                                name: method_name,
                                visibility: :protected,
                                instance_method: true
                            )
                        }
                    )
                    
                    all_methods.concat(
                        a_module.public_instance_methods(false).collect { |method_name|
                            Sirens::Method.new(
                                mod: a_module,
                                name: method_name,
                                visibility: :public,
                                instance_method: true
                            )
                        }
                    )
                else
                    all_methods.concat(
                        a_module.private_methods(false).collect { |method_name|
                            Sirens::Method.new(
                                mod: a_module,
                                name: method_name,
                                visibility: :private,
                                instance_method: false
                            )
                        }
                    )

                    all_methods.concat(
                        a_module.protected_methods(false).collect { |method_name|
                            Sirens::Method.new(
                                mod: a_module,
                                name: method_name,
                                visibility: :protected,
                                instance_method: false
                            )
                        }
                    )
                    
                    all_methods.concat(
                        a_module.public_methods(false).collect { |method_name|
                            Sirens::Method.new(
                                mod: a_module,
                                name: method_name,
                                visibility: :public,
                                instance_method: false
                            )
                        }
                    )
                end
            end

            all_methods.sort_by { |method| method.name }
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
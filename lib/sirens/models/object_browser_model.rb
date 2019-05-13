module Sirens
    class ObjectBrowserModel

        # Initializing

        def initialize()
            super()

            @object = ValueModel.on(nil)

            @object_instance_variables = TreeChoiceModel.new(
                    selection: object,
                    roots: [InstanceVariable.new(key: nil, value: object)],
                    get_children_block: proc { |instance_variable|
                        get_child_instance_variables_of(instance_variable.value)
                    }
                )

            @text = ValueModel.on('')

            connect_models
        end

        def connect_models()
            @object.add_observer(self, :on_object_changed)
            @object_instance_variables.selection.add_observer(self, :on_instance_variable_changed)
        end

        # Accessors

        attr_reader :object,
            :object_instance_variables,
            :text

        def selected_inst_var_value()
            tree_selection = object_instance_variables.selection.value.last

            tree_selection.nil? ? nil : tree_selection.value
        end

        # Events

        def on_object_changed(announcement)
            new_object = announcement.new_value

            @object_instance_variables.set_tree_roots(
                [InstanceVariable.new(key: nil, value: new_object)]
            )
        end

        def on_instance_variable_changed(announcement)
            instance_variable = announcement.new_value.last

            value = instance_variable.nil? ? '' : instance_variable.value.inspect

            @text.set_value(value)
        end

        ##
        # Get the child instance variables of an object.
        #
        def get_child_instance_variables_of(object)
            if object.kind_of?(Array)
                i = -1
                object.collect{ |value|
                    i += 1
                    InstanceVariable.new(
                        key: i,
                        value: value
                    )
                }
            elsif object.kind_of?(Hash)
              object.collect{ |key, value|
                  InstanceVariable.new(
                      key: "[#{key.inspect}]",
                      value: value
                  )
              }
            else
                object.instance_variables.collect{ |inst_var_name|
                    InstanceVariable.new(
                        key: inst_var_name,
                        value: object.instance_variable_get(inst_var_name)
                    )
                }
            end
        end

        class InstanceVariable
            def initialize(key:, value:)
                @key = key
                @value = value
            end

            attr_reader :key, :value

            def display_string()
                return value_display_string if key.nil?

                "#{key_display_string} = #{value_display_string}"
            end

            def key_display_string()
                if key.kind_of?(Numeric)
                    "[#{key}]"
                else
                    key.to_s
                end
            end

            def value_display_string()
                return "an Array(#{value.size})" if value.kind_of?(Array)
                return 'a Hash' if value.kind_of?(Hash)

                string = value.to_s

                if string.start_with?('#<')
                    "a " + value.class.name
                else
                    value.inspect
                end
            end
        end
    end
end
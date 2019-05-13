module Sirens

    class ObjectBrowser < Sirens::Component

        def self.open_on(object:)
            self.open.tap { |browser|
                browser.model.object.set_value(object)
            }
        end

        # Model

        def default_model()
            ObjectBrowserModel.new
        end

        # Building

        def renderWith(layout)
            browser_model = model

            layout.render do |component|

                window do

                    styles title: 'Object Browser',
                        width: 400,
                        height: 400

                    vertical_splitter do

                        choices_tree do
                            model browser_model.object_instance_variables

                            styles splitter_proportion: 2.0/3.0

                            handlers on_selection_action: proc { |index_path:, item:|
                                component.browse(object: item.value)
                            }

                            column label: 'Instance variables',
                                get_text_block: proc { |inst_var| inst_var.display_string }

                            popup_menu { |menu:, menu_owner:|
                                selected_object = component.model.selected_inst_var_value

                                menu.item label: 'Browse it', enabled: ! selected_object.nil?,
                                    action: proc{ component.browse(object: selected_object) }

                                menu.separator

                                menu.item label: 'Browse class', enabled: ! selected_object.nil?,
                                    action: proc{ component.browse_class_of(object: selected_object) }
                            }
                        end

                        text do
                            model browser_model.text

                            styles(
                                splitter_proportion: 1.0/3.0,
                                wrap_mode: :char
                            )

                            popup_menu { |menu:, menu_owner:|
                                selected_text = menu_owner.selected_text

                                menu.separator

                                menu.item label: 'Browse it', enabled: ! selected_text.nil?,
                                    action: proc{ component.browse_text_selection(text: selected_text) }
                            }
                        end

                    end
                end
            end
        end

        # Actions

        def browse(object:)
            Sirens.browse(object: object)
        end

        def browse_class_of(object:)
            Sirens.browse(klass: object.class)
        end

        def browse_text_selection(text:)
            selected_object = model.selected_inst_var_value

            evaluation_result =
                begin
                    selected_object.instance_exec { eval(text) }
                rescue Exception => e
                    e
                end

            browse(object: evaluation_result)
        end
    end
end

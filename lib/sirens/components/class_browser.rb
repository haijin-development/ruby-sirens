module Sirens
    class ClassBrowser < Sirens::Component

        # Building

        def renderWith(layout)
            browser_model = model

            layout.render do |component|
                horizontal_splitter do
                    component AncestorsList.new(
                        model: browser_model.module_ancestors,
                        splitter_proportion: 1.0/3.0
                    )

                    tabs do
                        styles splitter_proportion: 2.0/3.0

                        component MethodsList.new(
                            model: browser_model.methods,
                            instance_or_class_methods_chooser: browser_model.instance_or_class_methods_chooser,
                            show_inherit_methods: browser_model.show_inherit_methods,
                            show_public_methods: browser_model.show_public_methods,
                            show_protected_methods: browser_model.show_protected_methods,
                            show_private_methods: browser_model.show_private_methods,
                            tab_label: 'Methods'
                        )

                        component ConstantsList.new(
                            model: browser_model.constants,
                            tab_label: 'Constants'
                        )
                    end
                end
            end
        end
    end
end

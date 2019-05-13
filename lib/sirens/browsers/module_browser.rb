module Sirens

    class ModuleBrowser < Sirens::Component

        def self.open_on(klass: nil)
            self.open.tap { |browser|
                if klass.kind_of?(Class)
                    browser.model.select_class(klass)
                else
                    browser.model.select_namespace(namespace)
                end
            }
        end

        # Model

        def default_model()
            ModuleBrowserModel.new
        end

        # Building

        def renderWith(layout)
            browser_model = model

            layout.render do |component|

                window do

                    styles title: 'Namespace Browser',
                        width: 900,
                        height: 400

                    vertical_splitter do

                        horizontal_splitter do

                            styles splitter_proportion: 1.0/2.0

                            component NamespacesList.new(
                                model: browser_model.namespaces,
                                splitter_proportion: 1.0/4.0
                            )

                            component ModulesList.new(
                                model: browser_model.modules,
                                splitter_proportion: 1.0/4.0,
                            )

                            component ClassBrowser.new(
                                model: browser_model,
                                splitter_proportion: 2.0/4.0
                            )
                        end

                        component MethodSourceCode.new(
                            model: browser_model.method_source_code,
                            splitter_proportion: 1.0/2.0
                        )

                    end

                end
            end
        end
    end
end

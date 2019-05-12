$LOAD_PATH.unshift( File.expand_path( File.dirname(__FILE__) + '/../lib') )

require 'haijin-gtk'

class MainWindow < Haijin::Gtk::Window
    def renderWith(layout)
        layout.render border_width: 10 do

            vertical_stack do
                list headers_visible: true,
                    headers_clickable: true,
                    rules_hint: true do

                        list_column label: 'First Name'
                        list_column label: 'Last Name'

                    end

                button label: 'Click me', on_clicked: proc{ puts 1 }
            end
        end
    end
end

MainWindow.openOn(Hash[])

Gtk.main
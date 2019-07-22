RSpec.describe 'When using a Tabs component' do
    before(:all) {
        class TabsTest < Sirens::Component

            def renderWith(layout)
                layout.render do |component|

                    tabs width: 300 do
                        styles height: 100

                        button tab_label: 'Tab 1',
                            label: 'Button 1'

                        button tab_label: 'Tab 2',
                            label: 'Button 2'
                    end

                end
             end

        end
    }

    let(:component) {
        TabsTest.new
    }

    let(:widget) {
        component.main_component
    }

    describe 'props' do
        it 'sets the props given in the constructor' do
            expect( widget.props[:width] ).to eq(300)
        end

        it 'sets the props given in the render block' do
            expect( widget.props[:height] ).to eq(100)
        end
    end

    describe 'view' do
        it 'instantiates a TabsView' do
            expect( widget.view ).to be_a(Sirens::TabsView)
        end
    end

    describe 'sets the label to each tab' do
        it 'instantiates a TabsView' do
            expect( widget.view.tab_label_at(index: 0) ).to eq('Tab 1')
            expect( widget.view.tab_label_at(index: 1) ).to eq('Tab 2')
        end
    end
end

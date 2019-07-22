RSpec.describe 'When using a vertical Splitter component' do
    before(:all) {
        class VerticalSplitterTest < Sirens::Component

            def renderWith(layout)
                layout.render do |component|

                    vertical_splitter width: 300 do
                        styles height: 100

                        button label: 'Button 1'
                        button label: 'Button 2'
                    end

                end
             end

        end
    }

    let(:component) {
        VerticalSplitterTest.new
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
        it 'instantiates a SplitterView' do
            expect( widget.view ).to be_a(Sirens::SplitterView)
        end
    end
end

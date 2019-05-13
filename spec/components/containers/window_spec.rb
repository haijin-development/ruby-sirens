RSpec.describe 'When using a Window component' do
    before(:all) {
        class WindowTest < Sirens::Component

            def renderWith(layout)
                layout.render do |component|

                    window width: 300, height: 100 do
                        styles title: 'Window Test'
                    end

                end
             end

        end
    }

    let(:component) {
        WindowTest.new
    }

    let(:widget) {
        component.main_component
    }

    describe 'props' do
        it 'sets the props given in the constructor' do
            expect( widget.props[:width] ).to eq(300)
            expect( widget.props[:height] ).to eq(100)
        end

        it 'sets the props given in the render block' do
            expect( widget.props[:title] ).to eq('Window Test')
        end
    end

    describe 'view' do
        it 'instantiates a WindowView' do
            expect( widget.view ).to be_a(Sirens::WindowView)
        end

        it 'styles the WindowView with the props' do
            expect( widget.view.title ).to eq('Window Test')
        end
    end
end

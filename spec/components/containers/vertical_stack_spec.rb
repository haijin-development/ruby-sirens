RSpec.describe 'When using a vertical Stack component' do
    before(:all) {
        class VerticalStackTest < Sirens::Component

            def render_with(layout)
                layout.render do |component|

                    vertical_stack width: 300 do
                        styles height: 100

                        button label: 'Button 1'
                        button label: 'Button 2'
                        button label: 'Button 3'
                    end

                end
             end

        end
    }

    let(:component) {
        VerticalStackTest.new
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
        it 'instantiates a StackView' do
            expect( widget.view ).to be_a(Sirens::StackView)
        end
    end

    describe 'when adding child components' do
        it 'stacks the components' do
            expect( widget.child_components[0].view.label ).to eq('Button 1')
            expect( widget.child_components[1].view.label ).to eq('Button 2')
            expect( widget.child_components[2].view.label ).to eq('Button 3')
        end
    end
end

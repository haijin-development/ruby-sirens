RSpec.describe 'When using a Button component' do
    before(:all) {
        class ButtonTest < Sirens::Component

            def initialize()
                super()

                @was_clicked = false
            end

            def render_with(layout)
                layout.render do |component|
                    button label: 'click',
                        on_clicked: proc{ component.was_clicked = true }
                end
             end

            def was_clicked()
                @was_clicked
            end

            def was_clicked=(boolean)
                @was_clicked = boolean
            end
        end
    }

    let(:component) {
        ButtonTest.new
    }

    let(:widget) {
        component.main_component
    }

    describe 'props' do
        it 'sets the props given in the constructor' do
            expect( widget.props[:label] ).to eq('click')
        end
    end

    describe 'view' do
        it 'instantiates a ButtonView' do
            expect( widget.view ).to be_a(Sirens::ButtonView)
        end

        it 'styles the ButtonView label' do
            expect( widget.view.label ).to eq('click')
        end
    end

    describe 'events' do
        it 'calls the on_clicked handler when its clicked' do
            widget.click

            expect( component.was_clicked ).to be true
        end
    end
end

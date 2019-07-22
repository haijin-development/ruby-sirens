RSpec.describe 'When using a Checkbox component' do
    before(:all) {
        class CheckboxTest < Sirens::Component

            def renderWith(layout)
                layout.render do |component|
                    checkbox label: 'click'
                end
            end
        end
    }

    let(:component) {
        CheckboxTest.new
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
        it 'instantiates a CheckboxView' do
            expect( widget.view ).to be_a(Sirens::CheckboxView)
        end

        it 'styles the CheckboxView label' do
            expect( widget.view.label ).to eq('click')
        end
    end

    describe 'events' do
        it 'updates its model when toggled' do
            widget.click

            expect( widget.model.value ).to be true
        end

        it 'updates the view when the model value changes' do
            widget.model.set_value(true)

            expect( widget.view.get_value ).to be true
        end
    end
end

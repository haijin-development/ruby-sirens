RSpec.describe 'When using a List component' do
    before(:all) {
        class ListTest < Sirens::Component

            def renderWith(layout)
                layout.render do |component|
                    list do
                        styles id: :namespace_list,
                            show_headers: true,
                            width: 200

                        column label: 'Namespaces',
                            get_text_block: proc{ |item| item }
                    end
                end
             end
        end
    }

    let(:component) {
        ListTest.new
    }

    let(:widget) {
        component.main_component
    }

    describe 'props' do
        it 'sets the props given in the constructor' do
            expect( widget.props[:show_headers] ).to eq(true)
        end
    end

    describe 'view' do
        it 'instantiates a ListView' do
            expect( widget.view ).to be_a(Sirens::ListView)
        end

        it 'styles the show_headers prop' do
            widget.set_props(show_headers: false)

            expect( widget.view.show_headers? ).to eq(false)
        end

        it 'styles the clickable_headers prop' do
            widget.set_props(clickable_headers: false)

            expect( widget.view.clickable_headers? ).to eq(false)
        end

        it 'styles the width prop' do
            widget.set_props(width: 100)

            expect( widget.view.width ).to eq(100)
        end

        it 'styles the height prop' do
            widget.set_props(height: 100)

            expect( widget.view.height ).to eq(100)
        end
    end

    describe 'when changing its list model' do
        let(:list) {
            [:a, :b, :c]
        }

        let(:list_model) {
            Sirens::ListModel.with_all(list)
        }

        it 'updates the view when the model changes' do

            widget.set_model(list_model)

            expect( widget.view.rows ).to eq(['a', 'b', 'c'])
        end

        it 'updates the view when the list changes' do

            widget.model.set_list(list)

            expect( widget.view.rows ).to eq(['a', 'b', 'c'])
        end

        it 'updates the view when adding an item an the end of the list' do

            widget.model.set_list(list)

            widget.model << 'd'

            expect( widget.view.rows ).to eq(['a', 'b', 'c', 'd'])
        end

        it 'updates the view when adding an item an the begin of the list' do

            widget.model.set_list(list)

            widget.model.add_at(index: 0, items: ['d'])

            expect( widget.view.rows ).to eq(['d', 'a', 'b', 'c'])
        end

        it 'updates the view when updating an item of the list' do

            widget.model.set_list(list)

            widget.model.update_at(indices: [0, 2], items: ['a1', 'c1'])

            expect( widget.view.rows ).to eq(['a1', 'b', 'c1'])
        end

        it 'updates the view when removing an item of the list' do

            widget.model.set_list(list)

            widget.model.remove_at(indices: [0, 2])

            expect( widget.view.rows ).to eq(['b'])
        end
    end
end

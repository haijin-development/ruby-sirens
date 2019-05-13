RSpec.describe 'When using a ListModel' do

    before(:each) {
        @announced = false
    }

    describe 'on its creation' do

        it 'initializes to an empty list' do
            list_model = Sirens::ListModel.new

            expect( list_model.value ).to eq []
        end

        it 'sets the initial list' do
            list_model = Sirens::ListModel.on([1,2,3])

            expect( list_model.value ).to eq([1,2,3])
        end

    end

    describe 'when setting a new list' do

        it 'sets the new list' do
            list_model = Sirens::ListModel.new

            list_model.set_list([1,2,3])

            expect( list_model.value ).to eq([1,2,3])
        end

        it 'sets the new list using ::set_value' do
            list_model = Sirens::ListModel.new

            list_model.set_value([1,2,3])

            expect( list_model.value ).to eq([1,2,3])
        end

        it 'announces the list change' do
            list_model = Sirens::ListModel.new

            list_model.add_observer(self, :announced_list_changed)

            list_model.set_value([1,2,3])

            expect( @announced ).to be true
        end

        it 'does not make an announcement if the list is the same' do
            list_model = Sirens::ListModel.on([1,2,3])

            list_model.add_observer(self, :announced_list_changed)

            list_model.set_value([1,2,3])

            expect( @announced ).to be false
        end

        def announced_list_changed(announcement)
            @announced = true

            expect( announcement.old_list ).to eq []
            expect( announcement.new_list ).to eq([1,2,3])
        end

    end

    describe 'when adding an item to the list with <<' do

        it 'adds the item list' do
            list_model = Sirens::ListModel.on([1,2,3])

            list_model << 4

            expect( list_model.value ).to eq([1,2,3,4])
        end

        it 'announces the item added' do
            list_model = Sirens::ListModel.on([1,2,3])

            list_model.add_observer(self, :announced_item_added)

            list_model << 4

            expect( @announced ).to be true
        end

        def announced_item_added(announcement)
            @announced = true

            expect( announcement.list ).to eq [1,2,3,4]
            expect( announcement.index ).to eq(-1)
            expect( announcement.items ).to eq([4])
        end

    end

end

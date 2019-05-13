RSpec.describe 'When using a ValueModel' do

    before(:each) {
        @announced = false
    }

    describe 'on its creation' do

        it 'initializes to nil' do
            value_model = Sirens::ValueModel.new

            expect( value_model.value ).to be nil
        end

        it 'sets the initial value' do
            value_model = Sirens::ValueModel.on(123)

            expect( value_model.value ).to eq(123)
        end

    end

    describe 'when setting a value' do

        it 'sets the new value' do
            value_model = Sirens::ValueModel.new

            value_model.set_value(123)

            expect( value_model.value ).to eq(123)
        end

        it 'announces the value change' do
            value_model = Sirens::ValueModel.new

            value_model.add_observer(self, :announced)

            value_model.set_value(123)

            expect( @announced ).to be true
        end

        it 'does not make an announcement if the value is the same' do
            value_model = Sirens::ValueModel.on(123)

            value_model.add_observer(self, :announced)

            value_model.set_value(123)

            expect( @announced ).to be false
        end

        it 'force an announcement' do
            value_model = Sirens::ValueModel.on(123)

            value_model.add_observer(self, :announced)

            value_model.announce_value_changed(new_value: value_model.value, old_value: nil)

            expect( @announced ).to be true
        end

        def announced(announcement)
            @announced = true

            expect( announcement.old_value ).to be nil
            expect( announcement.new_value ).to eq(123)
        end

    end

end

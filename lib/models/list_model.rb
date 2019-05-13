require 'observer'

module Sirens
    class ListModel
        include Observable

        class << self
            def with(item)
                self.on([items])
            end

            def with_all(items)
                self.on(items.clone)
            end

            def on(list)
                self.new(list)
            end
        end

        # Initializing

        def initialize(list = [])
            super()

            @list = list
        end

        # Accessing

        def list()
            @list
        end

        def set_list(new_list)
            return if @list == new_list

            old_list = @list

            @list = new_list

            changed

            notify_observers(
                ListChanged.new(new_list: new_list, old_list: old_list)
            )
        end

        def value()
            list
        end

        def set_value(new_list)
            set_list(new_list)
        end

        # Adding

        ##
        # Adds the given item at the end of the list.
        #
        def <<(item)
            add_at(items: [item], index: -1)
        end

        ##
        # Adds the given items at the end of the list.
        #
        def add_at(index:, items:)
            list.insert(index, *items)

            changed

            notify_observers(
                ItemsAdded.new(list: list, index: index, items: items)
            )
        end

        # Updating

        ##
        # Updates the items at the given indices in the list.
        #
        def update_at(indices:, items:)
            (0 ... items.size).each do |i|
                list[ indices[i] ] = items[i]
            end

            changed

            notify_observers(
                ItemsUpdated.new(list: list, indices: indices, items: items)
            )
        end

        # Removing

        ##
        # Removes the items at the given indices in the list.
        #
        def remove_at(indices:)
            indices = indices.sort.reverse
            items = []

            indices.sort.reverse.each do |i|
                items << list.delete_at(i)
            end

            changed

            notify_observers(
                ItemsRemoved.new(list: list, indices: indices, items: items)
            )
        end

        # Iterating

        include Enumerable

        def each(&block)
            @list.each(&block)
        end

        def [](index)
            @list[index]
        end

        def []=(index, value)
            @list[index] = value
        end
    end

    # Announcements

    class ListChanged
        def initialize(new_list:, old_list:)
            @new_list = new_list
            @old_list = old_list
        end

        attr_reader :new_list, :old_list
    end

    class ItemsAdded
        def initialize(list:, index:, items:)
            @list = list
            @index = index
            @items = items
        end

        attr_reader :list, :index, :items
    end

    class ItemsUpdated
        def initialize(list:, indices:, items:)
            @list = list
            @indices = indices
            @items = items
        end

        attr_reader :list, :indices, :items
    end

    class ItemsRemoved
        def initialize(list:, indices:, items:)
            @list = list
            @indices = indices
            @items = items
        end

        attr_reader :list, :indices, :items
    end
end